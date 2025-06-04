import 'package:start_to_run_app/domain/models/workout.dart';
import 'package:start_to_run_app/domain/repositories/workout_repository.dart';

class MockWorkoutRepository implements WorkoutRepository {
  final List<Workout> _workouts = [];
  int _nextId = 1;

  @override
  Future<List<Workout>> getAllWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    return List.from(_workouts);
  }

  @override
  Future<List<Workout>> getCompletedWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _workouts.where((w) => w.isCompleted).toList();
  }

  @override
  Future<List<Workout>> getPendingWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _workouts.where((w) => !w.isCompleted).toList();
  }

  @override
  Future<Workout?> getWorkoutById(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _workouts.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> insertWorkout(Workout workout) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final newWorkout = workout.copyWith(id: _nextId);
    _workouts.add(newWorkout);
    return _nextId++;
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
    }
  }

  @override
  Future<void> deleteWorkout(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _workouts.removeWhere((w) => w.id == id);
  }

  // Helper methods for testing
  void addWorkout(Workout workout) {
    _workouts.add(workout.copyWith(id: _nextId++));
  }

  void clear() {
    _workouts.clear();
    _nextId = 1;
  }

  int get length => _workouts.length;
}
