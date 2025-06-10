import 'package:shared_preferences/shared_preferences.dart';

/// Service that handles saving and loading training progress data to/from device storage
class PersistenceService {
  static const String _currentWeekKey = 'current_week';
  static const String _currentDayKey = 'current_day';
  static const String _completedTrainingDaysKey = 'completed_training_days';
  static const String _completedDaysKey = 'completed_days';
  static const String _firstLaunchKey = 'first_launch';

  /// Save training progress to device storage
  static Future<void> saveTrainingProgress({
    required int currentWeek,
    required int currentDay,
    required int completedTrainingDays,
    required List<bool> completedDays,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_currentWeekKey, currentWeek);
      await prefs.setInt(_currentDayKey, currentDay);
      await prefs.setInt(_completedTrainingDaysKey, completedTrainingDays);

      // Convert List<bool> to List<String> for storage
      final completedDaysString = completedDays
          .map((e) => e.toString())
          .toList();
      await prefs.setStringList(_completedDaysKey, completedDaysString);

      // Mark that the app has been launched before
      await prefs.setBool(_firstLaunchKey, false);

      print('Training progress saved successfully');
    } catch (e) {
      print('Error saving training progress: $e');
    }
  }

  /// Load training progress from device storage
  static Future<Map<String, dynamic>?> loadTrainingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if this is the first launch
      final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

      if (isFirstLaunch) {
        print('First launch detected - no saved data to load');
        return null;
      }

      final currentWeek = prefs.getInt(_currentWeekKey);
      final currentDay = prefs.getInt(_currentDayKey);
      final completedTrainingDays = prefs.getInt(_completedTrainingDaysKey);
      final completedDaysString = prefs.getStringList(_completedDaysKey);

      // If any required data is missing, return null
      if (currentWeek == null ||
          currentDay == null ||
          completedTrainingDays == null ||
          completedDaysString == null) {
        print('Incomplete training data found - using defaults');
        return null;
      }

      // Convert List<String> back to List<bool>
      final completedDays = completedDaysString
          .map((e) => e == 'true')
          .toList();

      // Validate data integrity
      if (completedDays.length != 70) {
        print('Invalid completed days data length - using defaults');
        return null;
      }

      if (currentWeek < 1 ||
          currentWeek > 10 ||
          currentDay < 1 ||
          currentDay > 7) {
        print('Invalid week/day data - using defaults');
        return null;
      }

      print(
        'Training progress loaded successfully: Week $currentWeek, Day $currentDay',
      );

      return {
        'currentWeek': currentWeek,
        'currentDay': currentDay,
        'completedTrainingDays': completedTrainingDays,
        'completedDays': completedDays,
      };
    } catch (e) {
      print('Error loading training progress: $e');
      return null;
    }
  }

  /// Clear all saved training progress (reset functionality)
  static Future<void> clearTrainingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_currentWeekKey);
      await prefs.remove(_currentDayKey);
      await prefs.remove(_completedTrainingDaysKey);
      await prefs.remove(_completedDaysKey);
      // Don't remove _firstLaunchKey to preserve that it's not a first launch

      print('Training progress cleared successfully');
    } catch (e) {
      print('Error clearing training progress: $e');
    }
  }

  /// Check if this is the first time the app is launched
  static Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_firstLaunchKey) ?? true;
    } catch (e) {
      print('Error checking first launch: $e');
      return true;
    }
  }

  /// Save user settings (can be extended as needed)
  static Future<void> saveUserSettings({
    String? preferredNotificationTime,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (preferredNotificationTime != null) {
        await prefs.setString('notification_time', preferredNotificationTime);
      }
      if (soundEnabled != null) {
        await prefs.setBool('sound_enabled', soundEnabled);
      }
      if (vibrationEnabled != null) {
        await prefs.setBool('vibration_enabled', vibrationEnabled);
      }

      print('User settings saved successfully');
    } catch (e) {
      print('Error saving user settings: $e');
    }
  }

  /// Load user settings
  static Future<Map<String, dynamic>> loadUserSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'notificationTime': prefs.getString('notification_time') ?? '18:00',
        'soundEnabled': prefs.getBool('sound_enabled') ?? true,
        'vibrationEnabled': prefs.getBool('vibration_enabled') ?? true,
      };
    } catch (e) {
      print('Error loading user settings: $e');
      return {
        'notificationTime': '18:00',
        'soundEnabled': true,
        'vibrationEnabled': true,
      };
    }
  }
}
