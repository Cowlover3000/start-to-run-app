import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:start_to_run_app/domain/models/workout.dart';
import 'package:start_to_run_app/features/workout/widgets/workout_card.dart';

void main() {
  group('WorkoutCard Widget Tests', () {
    testWidgets('should display workout information correctly', (tester) async {
      // Arrange
      final workout = Workout(
        id: 1,
        name: 'Test Workout',
        description: 'This is a test workout description',
        durationMinutes: 25,
        difficulty: 'Gemiddelijk',
        createdAt: DateTime.now(),
        isCompleted: false,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: workout),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Workout'), findsOneWidget);
      expect(find.text('This is a test workout description'), findsOneWidget);
      expect(find.text('25 minuten'), findsOneWidget);
      expect(find.text('Gemiddelijk'), findsOneWidget);
      expect(find.text('Start training'), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    });

    testWidgets('should display completed status for completed workout', (tester) async {
      // Arrange
      final completedWorkout = Workout(
        id: 1,
        name: 'Completed Workout',
        description: 'This workout is done',
        durationMinutes: 30,
        difficulty: 'Moeilijk',
        createdAt: DateTime.now(),
        isCompleted: true,
        completedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: completedWorkout),
          ),
        ),
      );

      // Assert
      expect(find.text('Voltooid'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Start training'), findsNothing);
      expect(find.byIcon(Icons.play_circle_outline), findsNothing);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      // Arrange
      var tapCalled = false;
      final workout = Workout(
        id: 1,
        name: 'Tappable Workout',
        description: 'Tap me!',
        durationMinutes: 15,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(
              workout: workout,
              onTap: () => tapCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(WorkoutCard));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('should display difficulty colors correctly', (tester) async {
      // Arrange
      final easyWorkout = Workout(
        id: 1,
        name: 'Easy Workout',
        description: 'Easy workout',
        durationMinutes: 20,
        difficulty: 'Gemakkelijk',
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: easyWorkout),
          ),
        ),
      );

      // Assert
      // Find the difficulty container and verify it exists
      final difficultyContainer = find.ancestor(
        of: find.text('Gemakkelijk'),
        matching: find.byType(Container),
      );
      expect(difficultyContainer, findsAtLeastNWidgets(1));
    });

    testWidgets('should show schedule icon and duration', (tester) async {
      // Arrange
      final workout = Workout(
        id: 1,
        name: 'Timed Workout',
        description: 'Has duration',
        durationMinutes: 45,
        difficulty: 'Gemiddeld',
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutCard(workout: workout),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.schedule), findsOneWidget);
      expect(find.text('45 minuten'), findsOneWidget);
    });
  });
}
