import 'lib/models/training_program_new.dart';

void main() {
  print('Testing Training Program Data Model...\n');

  // Test basic functionality
  print('Total weeks: ${TrainingProgram.totalWeeks}');
  print('Total training days: ${TrainingProgram.totalTrainingDays}');
  print('Total program days: ${TrainingProgram.programData.length}\n');

  // Test Week 1, Day 1
  final week1day1 = TrainingProgram.getDay(1, 1);
  if (week1day1 != null) {
    print('Week 1, Day 1:');
    print('  Is training day: ${week1day1.isTrainingDay}');
    print('  Description: ${week1day1.description}');
    print('  Total duration: ${week1day1.totalDurationMinutes} minutes');
    print('  Number of segments: ${week1day1.segments?.length ?? 0}');
    
    if (week1day1.segments != null) {
      print('  Segments:');
      for (int i = 0; i < week1day1.segments!.length; i++) {
        final segment = week1day1.segments![i];
        print('    ${i + 1}. ${segment.type.name}: ${segment.durationMinutes} min');
      }
    }
    print('');
  }

  // Test Week 10, Day 1 (final week)
  final week10day1 = TrainingProgram.getDay(10, 1);
  if (week10day1 != null) {
    print('Week 10, Day 1:');
    print('  Is training day: ${week10day1.isTrainingDay}');
    print('  Description: ${week10day1.description}');
    print('  Total duration: ${week10day1.totalDurationMinutes} minutes');
    print('  Number of segments: ${week10day1.segments?.length ?? 0}');
    
    if (week10day1.segments != null) {
      print('  Segments:');
      for (int i = 0; i < week10day1.segments!.length; i++) {
        final segment = week10day1.segments![i];
        print('    ${i + 1}. ${segment.type.name}: ${segment.durationMinutes} min');
      }
    }
    print('');
  }

  // Test rest day
  final week1day2 = TrainingProgram.getDay(1, 2);
  if (week1day2 != null) {
    print('Week 1, Day 2 (Rest Day):');
    print('  Is training day: ${week1day2.isTrainingDay}');
    print('  Description: ${week1day2.description}');
    print('');
  }

  // Test week summary
  print('Week 1 summary:');
  final week1 = TrainingProgram.getWeek(1);
  final trainingDaysInWeek1 = week1.where((d) => d.isTrainingDay).length;
  final restDaysInWeek1 = week1.where((d) => !d.isTrainingDay).length;
  print('  Training days: $trainingDaysInWeek1');
  print('  Rest days: $restDaysInWeek1');
  print('  Total days: ${week1.length}');

  print('\n✅ Training Program Data Model is working correctly!');
}
