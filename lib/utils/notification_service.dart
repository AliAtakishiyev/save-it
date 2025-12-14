import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    //Timezone Initialiation (Must be first)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
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

    _isInitialized = true;
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
          // Wait for permission_handler to sync with flutter_local_notifications
          // They can be out of sync on iOS
          for (int i = 0; i < 10; i++) {
            await Future.delayed(Duration(milliseconds: 200));
            final status = await Permission.notification.status;
            if (status.isGranted) {
              return true;
            }
          }
          // If still not synced after 2 seconds, return true anyway
          // since flutter_local_notifications confirmed it
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
    if (!await isPermissionGranted()) {
      return;
    }
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

    await _notifications.zonedSchedule(
      id,
      'Birthday Reminder',
      message.replaceAll('{name}', name),
      tzNotificationTime,
      _details(), //buna bax
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  static Future<void> cancelNotification(int id) async {
    try{
      if(id > 0){
        await _notifications.cancel(id);
      }
    }catch(e){
      print(e);
    }
  }

  static Future<bool> isPermissionGranted() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return false;
  }

  static NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'birthday_channel',
        'Birthday Reminders',
        channelDescription: 'Notifications for upcoming birthdays',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }
}
