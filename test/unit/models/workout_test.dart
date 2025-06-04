import 'package:flutter_test/flutter_test.dart';
import 'package:start_to_run_app/domain/models/workout.dart';

void main() {
  group('Workout Model Tests', () {
    test('should create a workout with required fields', () {
      // Arrange
      final createdAt = DateTime.now();
      
      // Act
      final workout = Workout(
        name: 'Test Workout',
        description: 'A test workout',
        durationMinutes: 30,
        difficulty: 'Gemakkelijk',
        createdAt: createdAt,
      );
      
      // Assert
      expect(workout.name, 'Test Workout');
      expect(workout.description, 'A test workout');
      expect(workout.durationMinutes, 30);
      expect(workout.difficulty, 'Gemakkelijk');
      expect(workout.createdAt, createdAt);
      expect(workout.isCompleted, false);
      expect(workout.completedAt, null);
      expect(workout.id, null);
    });

    test('should create a completed workout', () {
      // Arrange
      final createdAt = DateTime.now();
      final completedAt = DateTime.now().add(const Duration(hours: 1));
      
      // Act
      final workout = Workout(
        id: 1,
        name: 'Completed Workout',
        description: 'A completed workout',
        durationMinutes: 20,
        difficulty: 'Gemiddeld',
        createdAt: createdAt,
        completedAt: completedAt,
        isCompleted: true,
      );
      
      // Assert
      expect(workout.id, 1);
      expect(workout.isCompleted, true);
      expect(workout.completedAt, completedAt);
    });

    test('should copy workout with new values', () {
      // Arrange
      final originalWorkout = Workout(
        name: 'Original',
        description: 'Original description',
        durationMinutes: 15,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );
      
      // Act
      final copiedWorkout = originalWorkout.copyWith(
        name: 'Updated',
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      
      // Assert
      expect(copiedWorkout.name, 'Updated');
      expect(copiedWorkout.description, 'Original description'); // unchanged
      expect(copiedWorkout.isCompleted, true);
      expect(copiedWorkout.completedAt, isNotNull);
    });

    test('should convert to and from JSON', () {
      // Arrange
      final createdAt = DateTime.now();
      final workout = Workout(
        id: 1,
        name: 'JSON Test',
        description: 'Test JSON conversion',
        durationMinutes: 25,
        difficulty: 'Moeilijk',
        createdAt: createdAt,
      );
      
      // Act
      final json = workout.toJson();
      final fromJson = Workout.fromJson(json);
      
      // Assert
      expect(fromJson.id, workout.id);
      expect(fromJson.name, workout.name);
      expect(fromJson.description, workout.description);
      expect(fromJson.durationMinutes, workout.durationMinutes);
      expect(fromJson.difficulty, workout.difficulty);
      expect(fromJson.createdAt, workout.createdAt);
      expect(fromJson.isCompleted, workout.isCompleted);
    });
  });
}
