import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/feedback_service.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundSignals = true;
  bool _hapticFeedback = true;
  bool _notifications = true;
  bool _trainingReminders = true;
  TimeOfDay _trainingReminderTime = const TimeOfDay(hour: 18, minute: 0); // 6:00 PM
  bool _restDayReminders = false; // Based on UX, initially off
  String _units = 'Metrisch'; // Default to Metric
  bool _gpsTracking = false; // GPS tracking setting

  // Notification service instance
  final NotificationService _notificationService = NotificationService();
  final FeedbackService _feedbackService = FeedbackService();

  // Notification IDs
  static const int _trainingReminderNotificationId = 0;
  static const int _restDayReminderNotificationId = 1;

  // Getters
  bool get soundSignals => _soundSignals;
  bool get hapticFeedback => _hapticFeedback;
  bool get notifications => _notifications;
  bool get trainingReminders => _trainingReminders;
  TimeOfDay get trainingReminderTime => _trainingReminderTime;
  bool get restDayReminders => _restDayReminders;
  String get units => _units;
  bool get gpsTracking => _gpsTracking;

  SettingsProvider() {
    _loadSettings();
    _initializeNotifications();
    _initializeFeedbackService();
  }

  // Initialize notification service
  Future<void> _initializeNotifications() async {
    await _notificationService.init();
    await _notificationService.requestPermissions();
  }

  // Initialize feedback service
  Future<void> _initializeFeedbackService() async {
    await _feedbackService.initialize(
      soundEnabled: _soundSignals,
      hapticEnabled: _hapticFeedback,
    );
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundSignals = prefs.getBool('soundSignals') ?? true;
    _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
    _notifications = prefs.getBool('notifications') ?? true;
    _trainingReminders = prefs.getBool('trainingReminders') ?? true;
    final reminderHour = prefs.getInt('trainingReminderHour') ?? 18;
    final reminderMinute = prefs.getInt('trainingReminderMinute') ?? 0;
    _trainingReminderTime = TimeOfDay(hour: reminderHour, minute: reminderMinute);
    _restDayReminders = prefs.getBool('restDayReminders') ?? false;
    _units = prefs.getString('units') ?? 'Metrisch';
    _gpsTracking = prefs.getBool('gpsTracking') ?? false;
    
    // Schedule notifications based on loaded settings
    _scheduleNotificationsBasedOnSettings();
    
    notifyListeners();
  }

  // Schedule notifications based on current settings
  Future<void> _scheduleNotificationsBasedOnSettings() async {
    if (_notifications) {
      if (_trainingReminders) {
        await _scheduleTrainingReminder();
      }
      if (_restDayReminders) {
        await _scheduleRestDayReminder();
      }
    }
  }

  // Setters and save to SharedPreferences
  void setSoundSignals(bool value) {
    _soundSignals = value;
    _saveSetting('soundSignals', value);
    _updateFeedbackService();
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _hapticFeedback = value;
    _saveSetting('hapticFeedback', value);
    _updateFeedbackService();
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    _saveSetting('notifications', value);
    
    if (!value) {
      // Cancel all notifications if notifications are turned off
      _notificationService.cancelAllNotifications();
    } else {
      // Re-schedule notifications based on current settings if turning back on
      _scheduleNotificationsBasedOnSettings();
    }
    
    notifyListeners();
  }

  void setTrainingReminders(bool value) {
    _trainingReminders = value;
    _saveSetting('trainingReminders', value);
    
    if (_notifications) {
      if (value) {
        _scheduleTrainingReminder();
      } else {
        _notificationService.cancelNotification(_trainingReminderNotificationId);
      }
    }
    
    notifyListeners();
  }

  void setTrainingReminderTime(TimeOfDay value) {
    _trainingReminderTime = value;
    _saveSetting('trainingReminderHour', value.hour);
    _saveSetting('trainingReminderMinute', value.minute);
    
    // If training reminders are active and notifications are enabled, reschedule with the new time
    if (_notifications && _trainingReminders) {
      _scheduleTrainingReminder();
    }
    
    notifyListeners();
  }

  void setRestDayReminders(bool value) {
    _restDayReminders = value;
    _saveSetting('restDayReminders', value);
    
    if (_notifications) {
      if (value) {
        _scheduleRestDayReminder();
      } else {
        _notificationService.cancelNotification(_restDayReminderNotificationId);
      }
    }
    
    notifyListeners();
  }

  void setUnits(String value) {
    _units = value;
    _saveSetting('units', value);
    notifyListeners();
  }

  void setGpsTracking(bool value) {
    _gpsTracking = value;
    _saveSetting('gpsTracking', value);
    notifyListeners();
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    }
    // Add other types if needed
  }

  // Schedule training reminder notification
  Future<void> _scheduleTrainingReminder() async {
    await _notificationService.scheduleDailyTrainingReminder(
      id: _trainingReminderNotificationId,
      time: _trainingReminderTime,
      title: 'Tijd voor je training! 🏃‍♂️',
      body: 'Vergeet je dagelijkse hardloop-/wandeltraining niet. Je kunt het!',
    );
  }

  // Schedule rest day reminder notification
  Future<void> _scheduleRestDayReminder() async {
    // Schedule at 10:00 AM for rest day reminders
    const TimeOfDay restDayTime = TimeOfDay(hour: 10, minute: 0);
    await _notificationService.scheduleDailyRestDayReminder(
      id: _restDayReminderNotificationId,
      time: restDayTime,
      title: 'Vandaag is een rustdag! 😌',
      body: 'Neem een welverdiende pauze en herstel voor je volgende training.',
    );
  }

  // Method to reset all settings and progress
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all app preferences
    await prefs.clear();

    // Cancel all notifications
    await _notificationService.cancelAllNotifications();

    // Re-load default settings after clear
    _soundSignals = true;
    _hapticFeedback = true;
    _notifications = true;
    _trainingReminders = true;
    _trainingReminderTime = const TimeOfDay(hour: 18, minute: 0);
    _restDayReminders = false;
    _units = 'Metrisch';
    _gpsTracking = false;
    
    // Update feedback service with default settings
    _updateFeedbackService();
    
    notifyListeners();
    
    // Save default settings again
    await _saveSettingsToDefaults();
  }

  Future<void> _saveSettingsToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundSignals', _soundSignals);
    await prefs.setBool('hapticFeedback', _hapticFeedback);
    await prefs.setBool('notifications', _notifications);
    await prefs.setBool('trainingReminders', _trainingReminders);
    await prefs.setInt('trainingReminderHour', _trainingReminderTime.hour);
    await prefs.setInt('trainingReminderMinute', _trainingReminderTime.minute);
    await prefs.setBool('restDayReminders', _restDayReminders);
    await prefs.setString('units', _units);
    await prefs.setBool('gpsTracking', _gpsTracking);
  }

  // Update feedback service with current settings
  void _updateFeedbackService() {
    _feedbackService.updateSettings(
      soundEnabled: _soundSignals,
      hapticEnabled: _hapticFeedback,
    );
  }

  // Format time for display
  String formatReminderTime(BuildContext context) {
    return _trainingReminderTime.format(context);
  }

  // Get available unit options
  List<String> get availableUnits => ['Metrisch', 'Imperiaal'];
}
