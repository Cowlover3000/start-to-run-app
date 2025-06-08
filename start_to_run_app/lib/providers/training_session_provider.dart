import 'package:flutter/foundation.dart';
import '../models/training_program.dart';

enum SessionStatus {
  notStarted,
  inProgress,
  paused,
  completed,
}

class TrainingSessionProvider extends ChangeNotifier {
  final TrainingProgram _trainingProgram = TrainingProgram.createFullProgram();
  
  int _currentWeek = 1;
  int _currentDayInWeek = 1;
  int _currentSegmentIndex = 0;
  SessionStatus _sessionStatus = SessionStatus.notStarted;
  Duration _elapsedTime = Duration.zero;
  DateTime? _sessionStartTime;
  DateTime? _pauseStartTime;
  Duration _totalPausedTime = Duration.zero;

  // Getters
  TrainingProgram get trainingProgram => _trainingProgram;
  int get currentWeek => _currentWeek;
  int get currentDayInWeek => _currentDayInWeek;
  SessionStatus get sessionStatus => _sessionStatus;
  Duration get elapsedTime => _elapsedTime;
  
  TrainingDay get currentDay {
    return _trainingProgram.getDay(_currentWeek, _currentDayInWeek);
  }
  
  TrainingSegment? get currentSegment {
    if (currentDay.isRestDay || _currentSegmentIndex >= currentDay.segments.length) {
      return null;
    }
    return currentDay.segments[_currentSegmentIndex];
  }
  
  int get currentSegmentIndex => _currentSegmentIndex;
  
  bool get hasNextSegment {
    return _currentSegmentIndex < currentDay.segments.length - 1;
  }
  
  bool get hasPreviousSegment {
    return _currentSegmentIndex > 0;
  }
  
  double get sessionProgress {
    if (currentDay.isRestDay) return 1.0;
    return (_currentSegmentIndex + 1) / currentDay.segments.length;
  }
  
  Duration get totalSessionDuration {
    return Duration(seconds: currentDay.totalDurationSeconds);
  }
  
  Duration get remainingTime {
    final total = totalSessionDuration;
    final elapsed = _elapsedTime;
    final remaining = total - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Navigation methods
  void selectDay(int week, int dayInWeek) {
    if (week >= 1 && week <= 10 && dayInWeek >= 1 && dayInWeek <= 7) {
      _currentWeek = week;
      _currentDayInWeek = dayInWeek;
      _resetSession();
      notifyListeners();
    }
  }
  
  void nextWeek() {
    if (_currentWeek < 10) {
      _currentWeek++;
      _currentDayInWeek = 1;
      _resetSession();
      notifyListeners();
    }
  }
  
  void previousWeek() {
    if (_currentWeek > 1) {
      _currentWeek--;
      _currentDayInWeek = 1;
      _resetSession();
      notifyListeners();
    }
  }
  
  void nextDay() {
    if (_currentDayInWeek < 7) {
      _currentDayInWeek++;
    } else if (_currentWeek < 10) {
      _currentWeek++;
      _currentDayInWeek = 1;
    }
    _resetSession();
    notifyListeners();
  }
  
  void previousDay() {
    if (_currentDayInWeek > 1) {
      _currentDayInWeek--;
    } else if (_currentWeek > 1) {
      _currentWeek--;
      _currentDayInWeek = 7;
    }
    _resetSession();
    notifyListeners();
  }

  // Session control methods
  void startSession() {
    if (currentDay.isRestDay) return;
    
    _sessionStatus = SessionStatus.inProgress;
    _sessionStartTime = DateTime.now();
    _pauseStartTime = null;
    _totalPausedTime = Duration.zero;
    _elapsedTime = Duration.zero;
    _currentSegmentIndex = 0;
    notifyListeners();
  }
  
  void pauseSession() {
    if (_sessionStatus == SessionStatus.inProgress) {
      _sessionStatus = SessionStatus.paused;
      _pauseStartTime = DateTime.now();
      notifyListeners();
    }
  }
  
  void resumeSession() {
    if (_sessionStatus == SessionStatus.paused && _pauseStartTime != null) {
      _sessionStatus = SessionStatus.inProgress;
      _totalPausedTime += DateTime.now().difference(_pauseStartTime!);
      _pauseStartTime = null;
      notifyListeners();
    }
  }
  
  void stopSession() {
    _sessionStatus = SessionStatus.notStarted;
    _resetSession();
    notifyListeners();
  }
  
  void completeSession() {
    _sessionStatus = SessionStatus.completed;
    notifyListeners();
  }
  
  void nextSegment() {
    if (hasNextSegment) {
      _currentSegmentIndex++;
      notifyListeners();
    } else {
      completeSession();
    }
  }
  
  void previousSegment() {
    if (hasPreviousSegment) {
      _currentSegmentIndex--;
      notifyListeners();
    }
  }
  
  void updateElapsedTime() {
    if (_sessionStatus == SessionStatus.inProgress && _sessionStartTime != null) {
      final now = DateTime.now();
      _elapsedTime = now.difference(_sessionStartTime!) - _totalPausedTime;
      notifyListeners();
    }
  }
  
  void _resetSession() {
    _sessionStatus = SessionStatus.notStarted;
    _currentSegmentIndex = 0;
    _elapsedTime = Duration.zero;
    _sessionStartTime = null;
    _pauseStartTime = null;
    _totalPausedTime = Duration.zero;
  }
  
  // Helper methods
  String getFormattedTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  String getCurrentSegmentDescription() {
    final segment = currentSegment;
    if (segment == null) return 'Rest Day';
    
    final activityName = segment.activityType == ActivityType.running ? 'Run' : 'Walk';
    return '$activityName for ${getFormattedTime(segment.duration)}';
  }
}
