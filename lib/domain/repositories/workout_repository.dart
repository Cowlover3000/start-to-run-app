import '../models/workout.dart';

abstract class WorkoutRepository {
  Future<List<Workout>> getAllWorkouts();
  Future<Workout?> getWorkoutById(int id);
  Future<int> insertWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> deleteWorkout(int id);
  Future<List<Workout>> getCompletedWorkouts();
  Future<List<Workout>> getPendingWorkouts();
}
