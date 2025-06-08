// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:start_to_run_app/main.dart';

void main() {
  testWidgets('Home Screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StartToRunApp());

    // Verify that our Home Screen elements are displayed.
    expect(find.text('Home Screen'), findsOneWidget);
    expect(find.text('Week 3'), findsOneWidget);
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Week 3 - Uithoudingsvermogen'), findsOneWidget);
    expect(find.text('Vandaag'), findsOneWidget);
    expect(find.text('Trainingsdag'), findsOneWidget);
    expect(find.text('Start Training'), findsOneWidget);
    expect(find.text('Morgen'), findsOneWidget);
    expect(find.text('Rustdag'), findsOneWidget);
  });
}
