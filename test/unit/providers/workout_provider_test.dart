import 'package:flutter_test/flutter_test.dart';
import 'package:start_to_run_app/domain/models/workout.dart';
import 'package:start_to_run_app/features/workout/providers/workout_provider.dart';
import '../../mocks/mock_workout_repository.dart';

void main() {
  group('WorkoutProvider Tests', () {
    late WorkoutProvider workoutProvider;
    late MockWorkoutRepository mockRepository;

    setUp(() {
      mockRepository = MockWorkoutRepository();
      workoutProvider = WorkoutProvider(mockRepository);
    });

    tearDown(() {
      mockRepository.clear();
    });

    test('should load workouts successfully', () async {
      // Arrange
      final workout1 = Workout(
        name: 'Workout 1',
        description: 'Description 1',
        durationMinutes: 20,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );
      final workout2 = Workout(
        name: 'Workout 2',
        description: 'Description 2',
        durationMinutes: 30,
        difficulty: 'Gemiddeld',
        createdAt: DateTime.now(),
        isCompleted: true,
        completedAt: DateTime.now(),
      );

      mockRepository.addWorkout(workout1);
      mockRepository.addWorkout(workout2);

      // Act
      await workoutProvider.loadWorkouts();

      // Assert
      expect(workoutProvider.workouts.length, 2);
      expect(workoutProvider.pendingWorkouts.length, 1);
      expect(workoutProvider.completedWorkouts.length, 1);
      expect(workoutProvider.isLoading, false);
      expect(workoutProvider.errorMessage, null);
    });

    test('should handle loading state correctly', () async {
      // Arrange
      expect(workoutProvider.isLoading, false);

      // Act
      final loadingFuture = workoutProvider.loadWorkouts();
      
      // Assert - should be loading
      expect(workoutProvider.isLoading, true);
      
      await loadingFuture;
      
      // Assert - should not be loading anymore
      expect(workoutProvider.isLoading, false);
    });

    test('should add workout successfully', () async {
      // Arrange
      final workout = Workout(
        name: 'New Workout',
        description: 'New Description',
        durationMinutes: 25,
        difficulty: 'Gemiddeld',
        createdAt: DateTime.now(),
      );

      // Act
      await workoutProvider.addWorkout(workout);

      // Assert
      expect(workoutProvider.workouts.length, 1);
      expect(workoutProvider.workouts.first.name, 'New Workout');
      expect(workoutProvider.workouts.first.id, isNotNull);
    });

    test('should complete workout successfully', () async {
      // Arrange
      final workout = Workout(
        name: 'Test Workout',
        description: 'Test Description',
        durationMinutes: 15,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );

      mockRepository.addWorkout(workout);
      await workoutProvider.loadWorkouts();
      
      final workoutId = workoutProvider.workouts.first.id!;

      // Act
      await workoutProvider.completeWorkout(workoutId);

      // Assert
      final updatedWorkout = workoutProvider.workouts.first;
      expect(updatedWorkout.isCompleted, true);
      expect(updatedWorkout.completedAt, isNotNull);
      expect(workoutProvider.completedWorkouts.length, 1);
      expect(workoutProvider.pendingWorkouts.length, 0);
    });

    test('should delete workout successfully', () async {
      // Arrange
      final workout = Workout(
        name: 'To Delete',
        description: 'Will be deleted',
        durationMinutes: 10,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );

      mockRepository.addWorkout(workout);
      await workoutProvider.loadWorkouts();
      
      final workoutId = workoutProvider.workouts.first.id!;
      expect(workoutProvider.workouts.length, 1);

      // Act
      await workoutProvider.deleteWorkout(workoutId);

      // Assert
      expect(workoutProvider.workouts.length, 0);
    });

    test('should filter pending and completed workouts correctly', () async {
      // Arrange
      final pendingWorkout = Workout(
        name: 'Pending',
        description: 'Not completed',
        durationMinutes: 20,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );

      final completedWorkout = Workout(
        name: 'Completed',
        description: 'Already done',
        durationMinutes: 30,
        difficulty: 'Gemiddeld',
        createdAt: DateTime.now(),
        isCompleted: true,
        completedAt: DateTime.now(),
      );

      mockRepository.addWorkout(pendingWorkout);
      mockRepository.addWorkout(completedWorkout);

      // Act
      await workoutProvider.loadWorkouts();

      // Assert
      expect(workoutProvider.workouts.length, 2);
      expect(workoutProvider.pendingWorkouts.length, 1);
      expect(workoutProvider.completedWorkouts.length, 1);
      expect(workoutProvider.pendingWorkouts.first.name, 'Pending');
      expect(workoutProvider.completedWorkouts.first.name, 'Completed');
    });
  });
}
