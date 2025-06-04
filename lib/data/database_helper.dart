import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/models/workout.dart';
import '../domain/repositories/workout_repository.dart';

class DatabaseHelper {
  static const String _databaseName = 'start_to_run.db';
  static const int _databaseVersion = 1;
  
  static const String tableWorkouts = 'workouts';
  
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  
  static Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableWorkouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        durationMinutes INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        completedAt TEXT,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
    
    // Insert default workouts
    await _insertDefaultWorkouts(db);
  }
  
  Future<void> _insertDefaultWorkouts(Database db) async {
    final defaultWorkouts = [
      {
        'name': 'Beginners Wandeling',
        'description': 'Een rustige 20-minuten wandeling voor beginners',
        'durationMinutes': 20,
        'difficulty': 'Gemakkelijk',
        'createdAt': DateTime.now().toIso8601String(),
        'isCompleted': 0,
      },
      {
        'name': 'Lichte Jogging',
        'description': 'Een 15-minuten lichte jogging',
        'durationMinutes': 15,
        'difficulty': 'Gemakkelijk',
        'createdAt': DateTime.now().toIso8601String(),
        'isCompleted': 0,
      },
      {
        'name': 'Interval Training',
        'description': 'Afwisselend hardlopen en wandelen gedurende 25 minuten',
        'durationMinutes': 25,
        'difficulty': 'Gemiddeld',
        'createdAt': DateTime.now().toIso8601String(),
        'isCompleted': 0,
      },
    ];
    
    for (final workout in defaultWorkouts) {
      await db.insert(tableWorkouts, workout);
    }
  }
}

class WorkoutRepositoryImpl implements WorkoutRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  
  @override
  Future<List<Workout>> getAllWorkouts() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(DatabaseHelper.tableWorkouts);
    return maps.map((map) => _workoutFromMap(map)).toList();
  }
  
  @override
  Future<Workout?> getWorkoutById(int id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableWorkouts,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _workoutFromMap(maps.first);
    }
    return null;
  }
  
  @override
  Future<int> insertWorkout(Workout workout) async {
    final db = await _databaseHelper.database;
    return await db.insert(DatabaseHelper.tableWorkouts, _workoutToMap(workout));
  }
  
  @override
  Future<void> updateWorkout(Workout workout) async {
    final db = await _databaseHelper.database;
    await db.update(
      DatabaseHelper.tableWorkouts,
      _workoutToMap(workout),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }
  
  @override
  Future<void> deleteWorkout(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      DatabaseHelper.tableWorkouts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<List<Workout>> getCompletedWorkouts() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableWorkouts,
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return maps.map((map) => _workoutFromMap(map)).toList();
  }
  
  @override
  Future<List<Workout>> getPendingWorkouts() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableWorkouts,
      where: 'isCompleted = ?',
      whereArgs: [0],
    );
    return maps.map((map) => _workoutFromMap(map)).toList();
  }
  
  Workout _workoutFromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      durationMinutes: map['durationMinutes'] as int,
      difficulty: map['difficulty'] as String,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
  
  Map<String, dynamic> _workoutToMap(Workout workout) {
    return {
      'id': workout.id,
      'name': workout.name,
      'description': workout.description,
      'durationMinutes': workout.durationMinutes,
      'difficulty': workout.difficulty,
      'completedAt': workout.completedAt?.toIso8601String(),
      'createdAt': workout.createdAt.toIso8601String(),
      'isCompleted': workout.isCompleted ? 1 : 0,
    };
  }
}
