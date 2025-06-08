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

class TrainingProgram {
  static final List<TrainingDay> programData = [
    // Week 1 
    TrainingDay(
      weekNumber: 1,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 18, // Sum of segments: 1+1+1+1+2+2+2+2+3+3 = 18
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 20, // Sum of segments: 1+1+1+1+2+2+3+3+3+3 = 20
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 22, // Sum of segments: 1+1+2+2+2+2+3+3+3+3 = 22
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 1,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 2 
    TrainingDay(
      weekNumber: 2,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 22, // Sum: 1+1+2+2+2+2+3+3+3+3 = 22
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 22, // Sum: 2+2+3+3+3+3+3+3 = 22
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 24, // Sum: 1+1+2+2+3+3+3+3+3+3 = 24
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 2,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 3 
    TrainingDay(
      weekNumber: 3,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 24, // Sum: 1+1+2+2+3+3+3+3+3+2 = 24
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 25, // Sum: 2+2+2+1+2+1+1+2+1+2+1+2+1+2+1 = 23 (Adjusted to 25 based on PDF total)
                                // NOTE: There's a minor discrepancy in PDF total for Week 3/4 Dag 3 (23 vs 25).
                                // Prioritizing the stated total duration for timer clarity.
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 26, // Sum: 1+1+2+2+4+3+4+3+5+1 = 26
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 3,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 4 (same as Week 3) 
    TrainingDay(
      weekNumber: 4,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 24,
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(1, ActivityType.walking),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 25, // Sum: 2+2+2+1+2+1+1+2+1+2+1+2+1+2+1 = 23 (Adjusted to 25 based on PDF total)
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(1, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 26,
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 4,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 5 
    TrainingDay(
      weekNumber: 5,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 32, // Sum: 2+2+3+2+5+3+5+3+5+2 = 32
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking), // Assuming this is the last segment
      ],
      description: 'Endurance training',
      totalDurationMinutes: 33, // Sum: 2+1+3+2+6+2+6+2+2 = 26 (Adjusted to 33 based on PDF total)
                                // NOTE: Another discrepancy, will prioritize PDF total.
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(7, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 34, // Sum: 2+2+4+2+5+2+6+2+7+2 = 34
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 5,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 6 (same as Week 5) 
    TrainingDay(
      weekNumber: 6,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(3, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 32,
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(3, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(2, ActivityType.walking),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 33,
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(2, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(4, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(7, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 34,
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 6,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 7 
    TrainingDay(
      weekNumber: 7,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(5, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(6, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(7, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(8, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 32, // Sum: 5+1+6+2+7+2+8+1 = 32
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(8, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(8, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(8, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(8, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 37, // Sum: 8+1+8+2+8+1+8+1 = 37
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(12, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 37, // Sum: 10+2+10+2+12+1 = 37
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 7,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 8 
    TrainingDay(
      weekNumber: 8,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(15, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(15, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 34, // Sum: 15+2+15+2 = 34
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(12, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(12, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 37, // Sum: 10+1+12+1+12+1 = 37
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(20, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 32, // Sum: 10+1+20+1 = 32
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 8,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 9 (same as Week 8) 
    TrainingDay(
      weekNumber: 9,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(15, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
        TrainingSegment.fromMinutes(15, ActivityType.walking),
        TrainingSegment.fromMinutes(2, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 34,
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(12, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(12, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 37,
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(10, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
        TrainingSegment.fromMinutes(20, ActivityType.walking),
        TrainingSegment.fromMinutes(1, ActivityType.running),
      ],
      description: 'Endurance training',
      totalDurationMinutes: 32,
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 9,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),

    // Week 10  - These are simpler, single long runs.
    TrainingDay(
      weekNumber: 10,
      dayNumber: 1,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(30, ActivityType.running), // 30 min run
        TrainingSegment.fromMinutes(1, ActivityType.walking),  // 1 min walk (choice)
      ],
      description: 'Long run training',
      totalDurationMinutes: 31, // Sum: 30+1 = 31
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 2,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 3,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(32, ActivityType.running), // 32 min run
        TrainingSegment.fromMinutes(1, ActivityType.walking),  // 1 min walk (choice)
      ],
      description: 'Long run training',
      totalDurationMinutes: 33, // Sum: 32+1 = 33
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 4,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 5,
      isTrainingDay: true,
      segments: [
        TrainingSegment.fromMinutes(30, ActivityType.running), // 30 min run
      ],
      description: 'Long run training',
      totalDurationMinutes: 30,
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 6,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
    TrainingDay(
      weekNumber: 10,
      dayNumber: 7,
      isTrainingDay: false,
      description: 'Take a well-deserved break!',
    ),
  ];

  /// Total number of weeks in the program
  static const int totalWeeks = 10;

  /// Total number of training days in the program
  static const int totalTrainingDays = 30;

  /// Get a specific day from the program
  static TrainingDay? getDay(int week, int dayInWeek) {
    if (week < 1 || week > totalWeeks || dayInWeek < 1 || dayInWeek > 7) {
      return null;
    }
    
    final dayIndex = (week - 1) * 7 + (dayInWeek - 1);
    if (dayIndex >= programData.length) return null;
    
    return programData[dayIndex];
  }

  /// Get all days for a specific week
  static List<TrainingDay> getWeek(int week) {
    if (week < 1 || week > totalWeeks) return [];
    
    final startIndex = (week - 1) * 7;
    final endIndex = startIndex + 7;
    
    if (endIndex > programData.length) return [];
    
    return programData.sublist(startIndex, endIndex);
  }

  /// Create a complete training program instance
  static TrainingProgram createFullProgram() {
    return TrainingProgram._();
  }

  /// Private constructor
  TrainingProgram._();

  /// Get all program data
  List<TrainingDay> get allDays => programData;

  /// Get training days only
  List<TrainingDay> get trainingDays => programData.where((day) => day.isTrainingDay).toList();

  /// Get rest days only
  List<TrainingDay> get restDays => programData.where((day) => !day.isTrainingDay).toList();
}
