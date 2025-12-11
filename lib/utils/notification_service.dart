import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,  // Don't auto-request, let user trigger it
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'birthday_channel',
        'Birthday Reminders',
        description: 'Notifications for upcoming birthdays',
        importance: Importance.high,
        playSound: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);
    }

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  static Future<void> initTimeZone() async {
    tz.initializeTimeZones();
    // tz.local will automatically use the system's local timezone
  }

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      // For Android 13+, try using flutter_local_notifications first
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final granted = await androidImplementation
          ?.requestNotificationsPermission();
      if (granted == true) {
        return true;
      }

      // Fallback to permission_handler
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // For iOS, use flutter_local_notifications to request permission
      final iosImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosImplementation != null) {
        // Check current status first
        final currentStatus = await Permission.notification.status;
        
        // If already granted, return true
        if (currentStatus.isGranted) {
          return true;
        }
        
        // If permanently denied, can't request again
        if (currentStatus.isPermanentlyDenied) {
          return false;
        }
        
        // Request permissions through flutter_local_notifications
        final result = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        if (result == true) {
          return true;
        }
        
        // Check status again after request
        final newStatus = await Permission.notification.status;
        return newStatus.isGranted;
      }

      // Fallback to permission_handler if flutter_local_notifications fails
      final status = await Permission.notification.status;
      if (status.isGranted) {
        return true;
      }
      if (status.isPermanentlyDenied) {
        return false;
      }
      
      final requestedStatus = await Permission.notification.request();
      return requestedStatus.isGranted;
    }
    return false;
  }

  static Future<void> scheduleBirthdayNotification({
    required int id,
    required String name,
    required DateTime birthDate,
    required String message,
  }) async {
    final now = DateTime.now();

    // Calculate this year's birthday
    final birthdayThisYear = DateTime(now.year, birthDate.month, birthDate.day);

    // Determine next birthday
    DateTime nextBirthday;
    if (birthdayThisYear.isAfter(now)) {
      nextBirthday = birthdayThisYear;
    } else {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    // Calculate notification time (24 hours before)
    final notificationTime = nextBirthday.subtract(Duration(hours: 24));

    // Convert to timezone-aware datetime
    final tzNotificationTime = tz.TZDateTime.from(notificationTime, tz.local);
    final tzNow = tz.TZDateTime.from(now, tz.local);

    // Only schedule if notification time is in the future
    if (tzNotificationTime.isBefore(tzNow)) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'birthday_channel',
      'Birthday Reminders',
      channelDescription: 'Notifications for upcoming birthdays',
      priority: Priority.high,
      importance: Importance.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      iOS: iosDetails,
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id,
      'Birthday Reminder',
      message.replaceAll('{name}', name),
      tzNotificationTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id); //hiveId
  }

  static Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return false;
  }
}
