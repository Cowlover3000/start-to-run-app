enum ActivityType {
  walking,
  running,
}

class TrainingSegment {
  final ActivityType type;
  final int durationSeconds;

  const TrainingSegment({
    required this.type,
    required this.durationSeconds,
  });

  factory TrainingSegment.fromMinutes(int minutes, ActivityType type) {
    return TrainingSegment(type: type, durationSeconds: minutes * 60);
  }

  /// Get duration in minutes for display purposes
  int get durationMinutes => (durationSeconds / 60).round();

  /// Get duration as Duration object
  Duration get duration => Duration(seconds: durationSeconds);

  /// Get activity type as ActivityType enum
  ActivityType get activityType => type;
}

class TrainingDay {
  final int weekNumber;
  final int dayNumber;
  final bool isTrainingDay;
  final List<TrainingSegment>? segments;
  final int? totalDurationMinutes;
  final String description;

  const TrainingDay({
    required this.weekNumber,
    required this.dayNumber,
    required this.isTrainingDay,
    this.segments,
    this.totalDurationMinutes,
    required this.description,
  });

  /// Factory constructor for training days
  factory TrainingDay.training({
    required int weekNumber,
    required int dayNumber,
    required String description,
    required List<TrainingSegment> segments,
    int? totalDurationMinutes,
  }) {
    final calculatedTotalSeconds = segments.fold<int>(
      0,
      (sum, segment) => sum + segment.durationSeconds,
    );
    final calculatedTotalMinutes = (calculatedTotalSeconds / 60).round();

    return TrainingDay(
      weekNumber: weekNumber,
      dayNumber: dayNumber,
      isTrainingDay: true,
      description: description,
      segments: segments,
      totalDurationMinutes: totalDurationMinutes ?? calculatedTotalMinutes,
    );
  }

  /// Factory constructor for rest days
  factory TrainingDay.rest({
    required int weekNumber,
    required int dayNumber,
    String description = 'Take a well-deserved break!',
  }) {
    return TrainingDay(
      weekNumber: weekNumber,
      dayNumber: dayNumber,
      isTrainingDay: false,
      description: description,
    );
  }

  /// Get total duration in seconds
  int get totalDurationSeconds {
    if (segments == null || segments!.isEmpty) return 0;
    return segments!.fold<int>(0, (sum, segment) => sum + segment.durationSeconds);
  }

  /// Check if this is a rest day
  bool get isRestDay => !isTrainingDay;
}

/// Contains the complete 10-week Start to Run training program
class TrainingProgram {
  static final List<TrainingDay> programData = [
    // Week 1
    TrainingDay.training(
      weekNumber: 1,
      dayNumber: 1,
      description: 'First step into running',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 1, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 1,
      dayNumber: 3,
      description: 'Building endurance',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 1, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 1,
      dayNumber: 5,
      description: 'Week 1 finale',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 1, dayNumber: 6),
    TrainingDay.rest(weekNumber: 1, dayNumber: 7),

    // Week 2
    TrainingDay.training(
      weekNumber: 2,
      dayNumber: 1,
      description: 'Longer running intervals',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 2, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 2,
      dayNumber: 3,
      description: 'Building consistency',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 2, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 2,
      dayNumber: 5,
      description: 'Week 2 completion',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 2, dayNumber: 6),
    TrainingDay.rest(weekNumber: 2, dayNumber: 7),

    // Week 3
    TrainingDay.training(
      weekNumber: 3,
      dayNumber: 1,
      description: 'Extended running periods',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 3, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 3,
      dayNumber: 3,
      description: 'Endurance building',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 3, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 3,
      dayNumber: 5,
      description: 'Week 3 milestone',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 3, dayNumber: 6),
    TrainingDay.rest(weekNumber: 3, dayNumber: 7),

    // Week 4
    TrainingDay.training(
      weekNumber: 4,
      dayNumber: 1,
      description: 'Increasing stamina',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 4, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 4,
      dayNumber: 3,
      description: 'Mid-week progress',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 4, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 4,
      dayNumber: 5,
      description: 'Week 4 achievement',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(5, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 4, dayNumber: 6),
    TrainingDay.rest(weekNumber: 4, dayNumber: 7),

    // Week 5
    TrainingDay.training(
      weekNumber: 5,
      dayNumber: 1,
      description: 'Continuous running begins',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 5, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 5,
      dayNumber: 3,
      description: 'Building endurance',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 5, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 5,
      dayNumber: 5,
      description: 'Week 5 progress',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 5, dayNumber: 6),
    TrainingDay.rest(weekNumber: 5, dayNumber: 7),

    // Week 6
    TrainingDay.training(
      weekNumber: 6,
      dayNumber: 1,
      description: 'Extended running sessions',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 6, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 6,
      dayNumber: 3,
      description: 'Consistency training',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 6, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 6,
      dayNumber: 5,
      description: 'Week 6 milestone',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 6, dayNumber: 6),
    TrainingDay.rest(weekNumber: 6, dayNumber: 7),

    // Week 7
    TrainingDay.training(
      weekNumber: 7,
      dayNumber: 1,
      description: 'Longer continuous runs',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(15, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 7, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 7,
      dayNumber: 3,
      description: 'Endurance development',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(15, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 7, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 7,
      dayNumber: 5,
      description: 'Week 7 achievement',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(15, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(10, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 7, dayNumber: 6),
    TrainingDay.rest(weekNumber: 7, dayNumber: 7),

    // Week 8
    TrainingDay.training(
      weekNumber: 8,
      dayNumber: 1,
      description: 'Major milestone approach',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(20, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 8, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 8,
      dayNumber: 3,
      description: 'Building towards continuous running',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(20, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 8, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 8,
      dayNumber: 5,
      description: 'Week 8 progress',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(20, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(8, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 8, dayNumber: 6),
    TrainingDay.rest(weekNumber: 8, dayNumber: 7),

    // Week 9
    TrainingDay.training(
      weekNumber: 9,
      dayNumber: 1,
      description: 'Almost there - continuous running',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(25, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 9, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 9,
      dayNumber: 3,
      description: 'Final preparation',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(25, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 9, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 9,
      dayNumber: 5,
      description: 'Week 9 completion',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(25, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 9, dayNumber: 6),
    TrainingDay.rest(weekNumber: 9, dayNumber: 7),

    // Week 10 - Final Week
    TrainingDay.training(
      weekNumber: 10,
      dayNumber: 1,
      description: 'Final week - you\'re a runner now!',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(30, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 10, dayNumber: 2),
    TrainingDay.training(
      weekNumber: 10,
      dayNumber: 3,
      description: 'Celebrating your progress',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(30, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 10, dayNumber: 4),
    TrainingDay.training(
      weekNumber: 10,
      dayNumber: 5,
      description: 'Graduation day - 30 minutes of continuous running!',
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(30, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
      ],
    ),
    TrainingDay.rest(weekNumber: 10, dayNumber: 6, description: 'Celebrate your achievement!'),
    TrainingDay.rest(weekNumber: 10, dayNumber: 7, description: 'You\'re now a runner! Plan your next goals.'),
  ];

  /// Get all training days for a specific week
  static List<TrainingDay> getWeek(int weekNumber) {
    return programData
        .where((day) => day.weekNumber == weekNumber)
        .toList();
  }

  /// Get a specific training day
  static TrainingDay? getDay(int weekNumber, int dayNumber) {
    try {
      return programData.firstWhere(
        (day) => day.weekNumber == weekNumber && day.dayNumber == dayNumber,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all training days (excluding rest days)
  static List<TrainingDay> getTrainingDaysOnly() {
    return programData.where((day) => day.isTrainingDay).toList();
  }

  /// Get the total number of weeks in the program
  static int get totalWeeks => 10;

  /// Get the total number of training days in the program
  static int get totalTrainingDays => 
      programData.where((day) => day.isTrainingDay).length;
}
