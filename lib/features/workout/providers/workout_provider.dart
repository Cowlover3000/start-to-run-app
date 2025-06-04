import 'package:flutter/foundation.dart';
import '../../../domain/models/workout.dart';
import '../../../domain/repositories/workout_repository.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository _workoutRepository;
  
  List<Workout> _workouts = [];
  List<Workout> _completedWorkouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutProvider(this._workoutRepository);

  List<Workout> get workouts => _workouts;
  List<Workout> get completedWorkouts => _completedWorkouts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<Workout> get pendingWorkouts => 
      _workouts.where((workout) => !workout.isCompleted).toList();

  Future<void> loadWorkouts() async {
    _setLoading(true);
    try {
      _workouts = await _workoutRepository.getAllWorkouts();
      _completedWorkouts = await _workoutRepository.getCompletedWorkouts();
      _clearError();
    } catch (e) {
      _setError('Fout bij het laden van trainingen: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      final id = await _workoutRepository.insertWorkout(workout);
      final newWorkout = workout.copyWith(id: id);
      _workouts.add(newWorkout);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Fout bij het toevoegen van training: ${e.toString()}');
    }
  }

  Future<void> completeWorkout(int workoutId) async {
    try {
      final workout = _workouts.firstWhere((w) => w.id == workoutId);
      final completedWorkout = workout.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      
      await _workoutRepository.updateWorkout(completedWorkout);
      
      final index = _workouts.indexWhere((w) => w.id == workoutId);
      if (index != -1) {
        _workouts[index] = completedWorkout;
        _completedWorkouts.add(completedWorkout);
      }
      
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Fout bij het voltooien van training: ${e.toString()}');
    }
  }

  Future<void> deleteWorkout(int workoutId) async {
    try {
      await _workoutRepository.deleteWorkout(workoutId);
      _workouts.removeWhere((w) => w.id == workoutId);
      _completedWorkouts.removeWhere((w) => w.id == workoutId);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Fout bij het verwijderen van training: ${e.toString()}');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
