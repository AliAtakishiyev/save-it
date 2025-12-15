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
      final android = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      return await android?.requestNotificationsPermission() ?? true;
    }

    if (Platform.isIOS) {
      final ios = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      return await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return false;
  }

  static Future<void> scheduleBirthdayNotification({
    required int id,
    required String name,
    required DateTime birthDate,
    required String message,
  }) async {
    if (!await isPermissionGranted()) return;

    final now = DateTime.now();

    // Birthday date this year (date-only)
    final birthdayThisYear = DateTime(now.year, birthDate.month, birthDate.day);

    // Determine next birthday
    final nextBirthday = birthdayThisYear.isAfter(now)
        ? birthdayThisYear
        : DateTime(now.year + 1, birthDate.month, birthDate.day);

    // 🔔 Notify 1 day before at 8 PM
    final notificationTime = DateTime(
      nextBirthday.year,
      nextBirthday.month,
      nextBirthday.day - 1,
      20, // 8 PM
    );

    // Convert to timezone-aware datetime
    final tzNotificationTime = tz.TZDateTime.from(notificationTime, tz.local);

    final tzNow = tz.TZDateTime.from(now, tz.local);

    // Only schedule future notifications
    if (tzNotificationTime.isBefore(tzNow)) return;

    await _notifications.zonedSchedule(
      id,
      'Birthday Reminder',
      message.replaceAll('{name}', name),
      tzNotificationTime,
      _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    try {
      if (id > 0) {
        await _notifications.cancel(id);
      }
    } catch (e) {
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
