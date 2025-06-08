import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/training_program_new.dart';
import '../services/feedback_service.dart';
import 'training_data_provider.dart';

enum SessionStatus { notStarted, inProgress, paused, completed }

class TrainingSessionProvider extends ChangeNotifier {
  int _currentSegmentIndex = 0;
  SessionStatus _sessionStatus = SessionStatus.notStarted;
  int _elapsedTime = 0; // in seconds
  int _currentSegmentElapsed = 0; // elapsed time in current segment
  Timer? _timer;
  TrainingDataProvider? _trainingDataProvider;
  final FeedbackService _feedbackService = FeedbackService();

  // Track if we've already given warnings for current segment
  bool _warningGiven = false;
  bool _countdownStarted = false;

  // Getters
  int get currentWeek => _trainingDataProvider?.currentWeek ?? 1;
  int get currentDayInWeek => _trainingDataProvider?.currentDay ?? 1;
  SessionStatus get sessionStatus => _sessionStatus;
  int get elapsedTime => _elapsedTime;
  bool get isRunning => _sessionStatus == SessionStatus.inProgress;

  TrainingDay? get currentDay {
    return TrainingProgram.getDay(currentWeek, currentDayInWeek);
  }

  TrainingSegment? get currentSegment {
    final day = currentDay;
    if (day == null ||
        day.isRestDay ||
        day.segments == null ||
        _currentSegmentIndex >= day.segments!.length) {
      return null;
    }
    return day.segments![_currentSegmentIndex];
  }

  int get currentSegmentIndex => _currentSegmentIndex;

  bool get hasNextSegment {
    final day = currentDay;
    if (day?.segments == null) return false;
    return _currentSegmentIndex < day!.segments!.length - 1;
  }

  bool get hasPreviousSegment {
    return _currentSegmentIndex > 0;
  }

  double get sessionProgress {
    final day = currentDay;
    if (day == null || day.isRestDay || day.segments == null) return 1.0;
    return (_currentSegmentIndex + 1) / day.segments!.length;
  }

  int get totalSessionDuration {
    return currentDay?.totalDurationSeconds ?? 0;
  }

  int get remainingTime {
    // Calculate total remaining time for the entire session
    final totalDuration = totalSessionDuration;
    if (totalDuration == 0) return 0;
    final remaining = totalDuration - _elapsedTime;
    return remaining > 0 ? remaining : 0;
  }

  int get currentSegmentRemainingTime {
    // Calculate remaining time for current segment only
    final segment = currentSegment;
    if (segment == null) return 0;
    final remaining = segment.durationSeconds - _currentSegmentElapsed;
    return remaining > 0 ? remaining : 0;
  }

  // Set the training data provider reference
  void setTrainingDataProvider(TrainingDataProvider trainingDataProvider) {
    _trainingDataProvider = trainingDataProvider;
  }

  // Navigation methods
  void selectDay(int week, int dayInWeek) {
    if (_trainingDataProvider != null &&
        week >= 1 &&
        week <= 10 &&
        dayInWeek >= 1 &&
        dayInWeek <= 7) {
      _trainingDataProvider!.goToWeek(week);
      _trainingDataProvider!.goToDay(dayInWeek);
      _resetSession();
      notifyListeners();
    }
  }

  void nextWeek() {
    if (_trainingDataProvider != null && currentWeek < 10) {
      _trainingDataProvider!.goToWeek(currentWeek + 1);
      _resetSession();
      notifyListeners();
    }
  }

  void previousWeek() {
    if (_trainingDataProvider != null && currentWeek > 1) {
      _trainingDataProvider!.goToWeek(currentWeek - 1);
      _resetSession();
      notifyListeners();
    }
  }

  void nextDay() {
    if (_trainingDataProvider != null) {
      if (currentDayInWeek < 7) {
        _trainingDataProvider!.goToDay(currentDayInWeek + 1);
      } else if (currentWeek < 10) {
        _trainingDataProvider!.goToWeek(currentWeek + 1);
        _trainingDataProvider!.goToDay(1);
      }
      _resetSession();
      notifyListeners();
    }
  }

  void previousDay() {
    if (_trainingDataProvider != null) {
      if (currentDayInWeek > 1) {
        _trainingDataProvider!.goToDay(currentDayInWeek - 1);
      } else if (currentWeek > 1) {
        _trainingDataProvider!.goToWeek(currentWeek - 1);
        _trainingDataProvider!.goToDay(7);
      }
      _resetSession();
      notifyListeners();
    }
  }

  // Session control methods
  void startSession() {
    final day = currentDay;
    if (day == null || day.isRestDay) return;

    _sessionStatus = SessionStatus.inProgress;
    _elapsedTime = 0;
    _currentSegmentElapsed = 0;
    _currentSegmentIndex = 0;
    _resetSegmentWarnings();
    _startTimer();
    notifyListeners();
  }

  void pauseSession() {
    if (_sessionStatus == SessionStatus.inProgress) {
      _sessionStatus = SessionStatus.paused;
      _stopTimer();
      notifyListeners();
    }
  }

  void resumeSession() {
    if (_sessionStatus == SessionStatus.paused) {
      _sessionStatus = SessionStatus.inProgress;
      _startTimer();
      notifyListeners();
    }
  }

  void stopSession() {
    _sessionStatus = SessionStatus.notStarted;
    _stopTimer();
    _resetSession();
    notifyListeners();
  }

  void completeSession() {
    _sessionStatus = SessionStatus.completed;
    _stopTimer();

    // Trigger completion feedback
    _feedbackService.sessionCompletionFeedback();

    // Mark the day as completed in the training data provider and advance to next day
    if (_trainingDataProvider != null) {
      _trainingDataProvider!
          .completeCurrentDay(); // This marks complete AND advances to next day
    }

    notifyListeners();
  }

  void nextSegment() {
    if (hasNextSegment) {
      _currentSegmentIndex++;
      _currentSegmentElapsed = 0;
      _resetSegmentWarnings();

      // Trigger feedback for segment transition
      _feedbackService.segmentTransitionFeedback();

      notifyListeners();
    } else {
      completeSession();
    }
  }

  void previousSegment() {
    if (hasPreviousSegment) {
      _currentSegmentIndex--;
      _currentSegmentElapsed = 0;
      _resetSegmentWarnings();
      notifyListeners();
    }
  }

  void _startTimer() {
    _stopTimer(); // Stop any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
      _currentSegmentElapsed++;

      // Check for feedback triggers
      _checkForFeedbackTriggers();

      // Check if current segment is completed
      final segment = currentSegment;
      if (segment != null &&
          _currentSegmentElapsed >= segment.durationSeconds) {
        if (hasNextSegment) {
          nextSegment();
        } else {
          completeSession();
        }
      }

      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resetSession() {
    _sessionStatus = SessionStatus.notStarted;
    _currentSegmentIndex = 0;
    _elapsedTime = 0;
    _currentSegmentElapsed = 0;
    _resetSegmentWarnings();
    _stopTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _feedbackService.dispose();
    super.dispose();
  }

  // Private helper methods for feedback
  void _checkForFeedbackTriggers() {
    final segment = currentSegment;
    if (segment == null) return;

    final remainingSeconds = segment.durationSeconds - _currentSegmentElapsed;

    // Give warning at 10 seconds remaining (only once per segment)
    if (remainingSeconds == 10 && !_warningGiven) {
      _warningGiven = true;
      _feedbackService.segmentWarningFeedback();
    }

    // Give countdown beeps for last 3 seconds (only once per second)
    if (remainingSeconds <= 3 && remainingSeconds > 0 && !_countdownStarted) {
      _countdownStarted = true;
      _startCountdown();
    }
  }

  void _startCountdown() async {
    final segment = currentSegment;
    if (segment == null) return;

    // Beep for 3, 2, 1
    for (int i = 3; i >= 1; i--) {
      final remainingSeconds = segment.durationSeconds - _currentSegmentElapsed;
      if (remainingSeconds == i) {
        await _feedbackService.countdownFeedback();
        await Future.delayed(const Duration(milliseconds: 800));
      }
    }
  }

  void _resetSegmentWarnings() {
    _warningGiven = false;
    _countdownStarted = false;
  }

  // Method to update feedback settings
  void updateFeedbackSettings({
    required bool soundEnabled,
    required bool hapticEnabled,
  }) {
    _feedbackService.updateSettings(
      soundEnabled: soundEnabled,
      hapticEnabled: hapticEnabled,
    );
  }

  // Helper methods
  String getFormattedTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String getCurrentSegmentDescription() {
    final segment = currentSegment;
    if (segment == null) return 'Rest Day';

    final activityName = segment.type == ActivityType.running
        ? 'Hardlopen'
        : 'Wandelen';
    return '$activityName voor ${getFormattedTime(segment.durationSeconds)}';
  }
}
