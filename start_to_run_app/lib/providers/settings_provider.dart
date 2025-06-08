import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundSignals = true;
  bool _notifications = true;
  bool _trainingReminders = true;
  TimeOfDay _trainingReminderTime = const TimeOfDay(hour: 18, minute: 0); // 6:00 PM
  bool _restDayReminders = false; // Based on UX, initially off
  String _units = 'Metrisch'; // Default to Metric
  bool _gpsTracking = false; // GPS tracking setting

  // Getters
  bool get soundSignals => _soundSignals;
  bool get notifications => _notifications;
  bool get trainingReminders => _trainingReminders;
  TimeOfDay get trainingReminderTime => _trainingReminderTime;
  bool get restDayReminders => _restDayReminders;
  String get units => _units;
  bool get gpsTracking => _gpsTracking;

  SettingsProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundSignals = prefs.getBool('soundSignals') ?? true;
    _notifications = prefs.getBool('notifications') ?? true;
    _trainingReminders = prefs.getBool('trainingReminders') ?? true;
    final reminderHour = prefs.getInt('trainingReminderHour') ?? 18;
    final reminderMinute = prefs.getInt('trainingReminderMinute') ?? 0;
    _trainingReminderTime = TimeOfDay(hour: reminderHour, minute: reminderMinute);
    _restDayReminders = prefs.getBool('restDayReminders') ?? false;
    _units = prefs.getString('units') ?? 'Metrisch';
    _gpsTracking = prefs.getBool('gpsTracking') ?? false;
    notifyListeners();
  }

  // Setters and save to SharedPreferences
  void setSoundSignals(bool value) {
    _soundSignals = value;
    _saveSetting('soundSignals', value);
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    _saveSetting('notifications', value);
    notifyListeners();
  }

  void setTrainingReminders(bool value) {
    _trainingReminders = value;
    _saveSetting('trainingReminders', value);
    notifyListeners();
  }

  void setTrainingReminderTime(TimeOfDay value) {
    _trainingReminderTime = value;
    _saveSetting('trainingReminderHour', value.hour);
    _saveSetting('trainingReminderMinute', value.minute);
    notifyListeners();
  }

  void setRestDayReminders(bool value) {
    _restDayReminders = value;
    _saveSetting('restDayReminders', value);
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

  // Method to reset all settings and progress
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all app preferences
    await prefs.clear();

    // Re-load default settings after clear
    _soundSignals = true;
    _notifications = true;
    _trainingReminders = true;
    _trainingReminderTime = const TimeOfDay(hour: 18, minute: 0);
    _restDayReminders = false;
    _units = 'Metrisch';
    _gpsTracking = false;
    notifyListeners();
    
    // Save default settings again
    await _saveSettingsToDefaults();
  }

  Future<void> _saveSettingsToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundSignals', _soundSignals);
    await prefs.setBool('notifications', _notifications);
    await prefs.setBool('trainingReminders', _trainingReminders);
    await prefs.setInt('trainingReminderHour', _trainingReminderTime.hour);
    await prefs.setInt('trainingReminderMinute', _trainingReminderTime.minute);
    await prefs.setBool('restDayReminders', _restDayReminders);
    await prefs.setString('units', _units);
    await prefs.setBool('gpsTracking', _gpsTracking);
  }

  // Format time for display
  String formatReminderTime(BuildContext context) {
    return _trainingReminderTime.format(context);
  }

  // Get available unit options
  List<String> get availableUnits => ['Metrisch', 'Imperiaal'];
}
