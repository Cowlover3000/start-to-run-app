import 'package:flutter/material.dart';
import '../models/training_program_new.dart';

/// Provider class that manages the training program state
class TrainingDataProvider extends ChangeNotifier {
  int _currentWeek = 1;
  int _currentDay = 1;
  int _completedTrainingDays = 0;
  List<bool> _completedDays = List.filled(
    70,
    false,
  ); // 70 total days (10 weeks * 7 days)

  // Getters
  int get currentWeek => _currentWeek;
  int get currentDay => _currentDay;
  int get completedTrainingDays => _completedTrainingDays;
  List<bool> get completedDays => _completedDays;

  /// Get the current training day object
  TrainingDay? get currentTrainingDay {
    return TrainingProgram.getDay(_currentWeek, _currentDay);
  }

  /// Get the next upcoming training day
  TrainingDay? get nextTrainingDay {
    // Look for the next training day starting from current position
    for (int week = _currentWeek; week <= TrainingProgram.totalWeeks; week++) {
      int startDay = (week == _currentWeek) ? _currentDay + 1 : 1;
      for (int day = startDay; day <= 7; day++) {
        final trainingDay = TrainingProgram.getDay(week, day);
        if (trainingDay != null && trainingDay.isTrainingDay) {
          return trainingDay;
        }
      }
    }
    return null;
  }

  /// Get all training days for the current week
  List<TrainingDay> get currentWeekDays {
    return TrainingProgram.getWeek(_currentWeek);
  }

  /// Get completion percentage (0.0 to 1.0)
  double get overallProgress {
    return _completedTrainingDays / TrainingProgram.totalTrainingDays;
  }

  /// Get current week progress (0.0 to 1.0)
  double get currentWeekProgress {
    final weekDays = TrainingProgram.getWeek(_currentWeek);
    final completedInWeek = weekDays.where((day) {
      final dayIndex = getDayIndex(day.weekNumber, day.dayNumber);
      return dayIndex < _completedDays.length && _completedDays[dayIndex];
    }).length;
    return completedInWeek / weekDays.length;
  }

  /// Get the number of training days completed this week
  int get completedTrainingDaysThisWeek {
    final weekDays = TrainingProgram.getWeek(_currentWeek);
    return weekDays.where((day) {
      if (!day.isTrainingDay) return false;
      final dayIndex = getDayIndex(day.weekNumber, day.dayNumber);
      return dayIndex < _completedDays.length && _completedDays[dayIndex];
    }).length;
  }

  /// Get the total number of training days in current week
  int get totalTrainingDaysThisWeek {
    return TrainingProgram.getWeek(
      _currentWeek,
    ).where((day) => day.isTrainingDay).length;
  }

  /// Helper method to convert week/day to array index
  int getDayIndex(int week, int day) {
    return (week - 1) * 7 + (day - 1);
  }

  /// Helper method to convert array index to week/day
  Map<String, int> getWeekDayFromIndex(int index) {
    final week = (index ~/ 7) + 1;
    final day = (index % 7) + 1;
    return {'week': week, 'day': day};
  }

  /// Mark a specific day as completed
  void completeDay(int week, int day) {
    final dayIndex = getDayIndex(week, day);
    if (dayIndex < _completedDays.length && !_completedDays[dayIndex]) {
      _completedDays[dayIndex] = true;

      // If it's a training day, increment the counter
      final trainingDay = TrainingProgram.getDay(week, day);
      if (trainingDay != null && trainingDay.isTrainingDay) {
        _completedTrainingDays++;
      }

      notifyListeners();
    }
  }

  /// Mark the current day as completed and advance to next day
  void completeCurrentDay() {
    completeDay(_currentWeek, _currentDay);
    advanceToNextDay();
  }

  /// Advance to the next day in the program
  void advanceToNextDay() {
    if (_currentDay < 7) {
      _currentDay++;
    } else if (_currentWeek < TrainingProgram.totalWeeks) {
      _currentWeek++;
      _currentDay = 1;
    }
    notifyListeners();
  }

  /// Go to a specific week
  void goToWeek(int week) {
    if (week >= 1 && week <= TrainingProgram.totalWeeks) {
      _currentWeek = week;
      _currentDay = 1;
      notifyListeners();
    }
  }

  /// Go to a specific day in the current week
  void goToDay(int day) {
    if (day >= 1 && day <= 7) {
      _currentDay = day;
      notifyListeners();
    }
  }

  /// Check if a specific day is completed
  bool isDayCompleted(int week, int day) {
    final dayIndex = getDayIndex(week, day);
    return dayIndex < _completedDays.length && _completedDays[dayIndex];
  }

  /// Reset all progress (for testing or restart)
  void resetProgress() {
    _currentWeek = 1;
    _currentDay = 1;
    _completedTrainingDays = 0;
    _completedDays = List.filled(70, false);
    notifyListeners();
  }

  /// Set progress manually (useful for testing or loading saved state)
  void setProgress({
    required int week,
    required int day,
    required int completedTrainingDays,
    required List<bool> completedDays,
  }) {
    _currentWeek = week;
    _currentDay = day;
    _completedTrainingDays = completedTrainingDays;
    _completedDays = List.from(completedDays);
    notifyListeners();
  }

  /// Get stats for the progress screen
  Map<String, dynamic> getProgressStats() {
    final totalDaysInProgram = 70;
    final totalDaysCompleted = _completedDays
        .where((completed) => completed)
        .length;
    final totalTrainingDaysInProgram = TrainingProgram.totalTrainingDays;

    // Calculate current streak
    int currentStreak = 0;
    for (int i = getDayIndex(_currentWeek, _currentDay) - 1; i >= 0; i--) {
      if (_completedDays[i]) {
        currentStreak++;
      } else {
        break;
      }
    }

    // Calculate longest streak
    int longestStreak = 0;
    int tempStreak = 0;
    for (bool completed in _completedDays) {
      if (completed) {
        tempStreak++;
        longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
      } else {
        tempStreak = 0;
      }
    }

    return {
      'totalDaysCompleted': totalDaysCompleted,
      'totalDaysInProgram': totalDaysInProgram,
      'completedTrainingDays': _completedTrainingDays,
      'totalTrainingDaysInProgram': totalTrainingDaysInProgram,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'overallProgress': overallProgress,
      'currentWeek': _currentWeek,
      'currentDay': _currentDay,
    };
  }

  /// Get the Dutch day name
  String getDutchDayName(int dayNumber) {
    const dayNames = [
      'Maandag',
      'Dinsdag',
      'Woensdag',
      'Donderdag',
      'Vrijdag',
      'Zaterdag',
      'Zondag',
    ];
    return dayNames[dayNumber - 1];
  }

  /// Get the training day type (Training Day or Rest Day)
  String getDayType(int week, int day) {
    final trainingDay = TrainingProgram.getDay(week, day);
    if (trainingDay == null) return 'Unknown';
    return trainingDay.isTrainingDay ? 'Trainingsdag' : 'Rustdag';
  }

  /// Get formatted duration string
  String formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}u';
      } else {
        return '${hours}u ${remainingMinutes}min';
      }
    }
  }
}
