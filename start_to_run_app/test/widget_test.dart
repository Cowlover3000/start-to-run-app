import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:start_to_run_app/main.dart';

void main() {
  testWidgets('App displays correctly with navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StartToRunApp());

    // Verify that our Home Screen elements are displayed.
    expect(find.text('Week 3'), findsOneWidget);
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Week 3 - Uithoudingsvermogen'), findsOneWidget);
    expect(find.text('Vandaag'), findsOneWidget);
    expect(find.text('Trainingsdag'), findsOneWidget);
    expect(find.text('Start Training'), findsOneWidget);
    expect(find.text('Morgen'), findsOneWidget);
    expect(find.text('Rustdag'), findsOneWidget);
    
    // Verify bottom navigation is present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Training'), findsOneWidget);
    expect(find.text('Voortgang'), findsOneWidget);
    expect(find.text('Instellingen'), findsOneWidget);
  });

  testWidgets('Navigation works correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StartToRunApp());

    // Test navigation to Progress screen
    await tester.tap(find.text('Voortgang').last); // Use .last to avoid ambiguity
    await tester.pumpAndSettle();
    
    // Should see Progress screen content
    expect(find.text('Trainingen\nVoltooid'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Programma Voortgang'), findsOneWidget);
    
    // Test navigation to Settings screen
    await tester.tap(find.text('Instellingen').last); // Use .last to avoid ambiguity
    await tester.pumpAndSettle();
    
    // Should see Settings screen content
    expect(find.text('Profiel'), findsOneWidget);
    expect(find.text('Audio coaching'), findsOneWidget);
    
    // Test navigation back to Home
    await tester.tap(find.text('Home').last); // Use .last to avoid ambiguity
    await tester.pumpAndSettle();
    
    // Should see Home screen content again
    expect(find.text('Week 3'), findsOneWidget);
    expect(find.text('Start Training'), findsOneWidget);
  });

  testWidgets('Start Training button switches to training tab', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StartToRunApp());

    // Verify we're on home screen
    expect(find.text('Week 3'), findsOneWidget);
    
    // Tap the Start Training button
    await tester.tap(find.text('Start Training'));
    await tester.pumpAndSettle();
    
    // Should navigate to Active Training screen
    expect(find.text('1:23'), findsOneWidget);
    expect(find.text('HARDLOPEN'), findsOneWidget);
    expect(find.text('Week 3, Dag 1'), findsOneWidget);
  });
}
