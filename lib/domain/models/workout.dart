import 'package:json_annotation/json_annotation.dart';

part 'workout.g.dart';

@JsonSerializable()
class Workout {
  final int? id;
  final String name;
  final String description;
  final int durationMinutes;
  final String difficulty;
  final DateTime? completedAt;
  final DateTime createdAt;
  final bool isCompleted;

  const Workout({
    this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.difficulty,
    this.completedAt,
    required this.createdAt,
    this.isCompleted = false,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutToJson(this);

  Workout copyWith({
    int? id,
    String? name,
    String? description,
    int? durationMinutes,
    String? difficulty,
    DateTime? completedAt,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      difficulty: difficulty ?? this.difficulty,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
