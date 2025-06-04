// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:start_to_run_app/main.dart';
import 'package:start_to_run_app/features/workout/providers/workout_provider.dart';
import 'mocks/mock_workout_repository.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should build app without errors', (tester) async {
      // Act
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should show main navigation with bottom navigation bar', (tester) async {
      // Arrange
      final mockRepository = MockWorkoutRepository();
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(mockRepository),
            child: const MyApp(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Voortgang'), findsOneWidget);
      expect(find.text('Profiel'), findsOneWidget);
      expect(find.text('Instellingen'), findsOneWidget);
    });

    testWidgets('should navigate between tabs', (tester) async {
      // Arrange
      final mockRepository = MockWorkoutRepository();
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => WorkoutProvider(mockRepository),
            child: const MyApp(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Progress tab
      await tester.tap(find.text('Voortgang'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Voortgang scherm komt binnenkort'), findsOneWidget);

      // Tap on Profile tab
      await tester.tap(find.text('Profiel'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Profiel scherm komt binnenkort'), findsOneWidget);
    });
  });
}
