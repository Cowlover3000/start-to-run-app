import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    
    // Set the local location for Netherlands/Belgium
    try {
      tz.setLocalLocation(tz.getLocation('Europe/Brussels'));
    } catch (e) {
      // Fallback to UTC if timezone not found
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings  
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Notification tapped: ${response.payload}');
        // Handle notification tap - could navigate to specific screen
      },
    );

    // Request permissions for Android 13+ and iOS
    await requestPermissions();
    
    debugPrint('Notification service initialized successfully');
  }

  // Schedule a daily training reminder notification
  Future<void> scheduleDailyTrainingReminder({
    required int id,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'training_reminder_channel_id',
          'Training Reminders',
          channelDescription: 'Daily reminders for your training sessions',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  // Schedule a rest day reminder notification
  Future<void> scheduleDailyRestDayReminder({
    required int id,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'rest_day_reminder_channel_id',
          'Rest Day Reminders',
          channelDescription: 'Reminders for your rest days',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  // Helper to calculate next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all pending notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // Get list of pending notifications (useful for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  // Request notification permissions (required for Android 13+ and iOS)
  Future<bool?> requestPermissions() async {
    // For iOS
    final iosImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      return iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    // For Android 13+
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      return androidImplementation.requestNotificationsPermission();
    }
    
    return null;
  }

  // Check if notifications are enabled
  Future<bool?> areNotificationsEnabled() async {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      return androidImplementation.areNotificationsEnabled();
    }
    return null;
  }

  // Show an immediate test notification
  Future<void> showTestNotification() async {
    await flutterLocalNotificationsPlugin.show(
      999, // Test notification ID
      'Test Notification',
      'Dit is een test notificatie van je Start to Run app!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel_id',
          'Test Notifications',
          channelDescription: 'Test notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default',
        ),
      ),
    );
  }
}
