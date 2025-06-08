import 'package:flutter_test/flutter_test.dart';
import 'package:start_to_run_app/models/training_program_new.dart';

void main() {
  group('TrainingProgram Data Model Tests', () {
    test('TrainingSegment factory constructor converts minutes to seconds', () {
      final segment = TrainingSegment.fromMinutes(5, ActivityType.walking);
      expect(segment.durationSeconds, equals(300)); // 5 * 60
      expect(segment.durationMinutes, equals(5));
      expect(segment.type, equals(ActivityType.walking));
    });

    test('TrainingDay factory constructors work correctly', () {
      // Test training day
      final trainingDay = TrainingDay.training(
        weekNumber: 1,
        dayNumber: 1,
        description: 'Test training',
        segments: [
          TrainingSegment.fromMinutes(5, ActivityType.walking),
          TrainingSegment.fromMinutes(1, ActivityType.running),
        ],
      );

      expect(trainingDay.isTrainingDay, isTrue);
      expect(trainingDay.segments, isNotNull);
      expect(trainingDay.totalDurationMinutes, equals(6)); // 5 + 1
      expect(trainingDay.segments!.length, equals(2));

      // Test rest day
      final restDay = TrainingDay.rest(weekNumber: 1, dayNumber: 2);
      expect(restDay.isTrainingDay, isFalse);
      expect(restDay.segments, isNull);
      expect(restDay.totalDurationMinutes, isNull);
    });

    test('TrainingProgram has correct structure', () {
      // Test total weeks and days
      expect(TrainingProgram.totalWeeks, equals(10));
      expect(
        TrainingProgram.programData.length,
        equals(70),
      ); // 10 weeks * 7 days

      // Test that we have exactly 30 training days (3 per week * 10 weeks)
      expect(TrainingProgram.totalTrainingDays, equals(30));

      // Test each week has 7 days
      for (int week = 1; week <= 10; week++) {
        final weekDays = TrainingProgram.getWeek(week);
        expect(weekDays.length, equals(7));
        expect(weekDays.where((day) => day.isTrainingDay).length, equals(3));
        expect(weekDays.where((day) => !day.isTrainingDay).length, equals(4));
      }
    });

    test('Program progression makes sense', () {
      // Week 1 should have shorter running segments than Week 10
      final week1Day1 = TrainingProgram.getDay(1, 1)!;
      final week10Day1 = TrainingProgram.getDay(10, 1)!;

      expect(week1Day1.isTrainingDay, isTrue);
      expect(week10Day1.isTrainingDay, isTrue);

      // Week 10 should have longer total duration than Week 1
      expect(
        week10Day1.totalDurationMinutes! > week1Day1.totalDurationMinutes!,
        isTrue,
      );

      // Week 10 should have fewer segments (longer continuous running)
      expect(week10Day1.segments!.length < week1Day1.segments!.length, isTrue);
    });

    test('Activity types alternate correctly in early weeks', () {
      final week1Day1 = TrainingProgram.getDay(1, 1)!;
      final segments = week1Day1.segments!;

      // Should start with walking
      expect(segments.first.type, equals(ActivityType.walking));

      // Should alternate between walking and running
      for (int i = 0; i < segments.length - 1; i++) {
        if (segments[i].type == ActivityType.walking) {
          expect(segments[i + 1].type, equals(ActivityType.running));
        } else {
          expect(segments[i + 1].type, equals(ActivityType.walking));
        }
      }
    });

    test('Week 10 is primarily running', () {
      final week10Day1 = TrainingProgram.getDay(10, 1)!;
      final segments = week10Day1.segments!;

      // Should have a long running segment in the middle
      final runningSegments = segments.where(
        (s) => s.type == ActivityType.running,
      );
      expect(runningSegments.isNotEmpty, isTrue);

      // The main running segment should be 30 minutes
      final mainRunningSegment = runningSegments.first;
      expect(mainRunningSegment.durationMinutes, equals(30));
    });

    test('Helper methods work correctly', () {
      // Test getDay
      final day = TrainingProgram.getDay(1, 1);
      expect(day, isNotNull);
      expect(day!.weekNumber, equals(1));
      expect(day.dayNumber, equals(1));

      // Test invalid day returns null
      final invalidDay = TrainingProgram.getDay(15, 1);
      expect(invalidDay, isNull);

      // Test getTrainingDaysOnly is replaced with filtering programData
      final trainingDays = TrainingProgram.programData
          .where((day) => day.isTrainingDay)
          .toList();
      expect(trainingDays.length, equals(30));
      expect(trainingDays.every((day) => day.isTrainingDay), isTrue);
    });
  });
}
