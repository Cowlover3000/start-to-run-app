import 'package:flutter/material.dart';
import 'models/training_program.dart';
// TODO: Uncomment these imports when implementing features
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const StartToRunApp());
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start to Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firstDay = TrainingProgram.getDay(1, 1);
    final lastDay = TrainingProgram.getDay(10, 5);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Start to Run'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Start to Run!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Program Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Program Overview',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Total weeks: ${TrainingProgram.totalWeeks}'),
                    Text('Total training days: ${TrainingProgram.totalTrainingDays}'),
                    Text('Training days per week: 3'),
                    Text('Rest days per week: 4'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // First Training Day Preview
            if (firstDay != null && firstDay.isTrainingDay) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your First Training Day',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Week ${firstDay.weekNumber}, Day ${firstDay.dayNumber}'),
                      Text('Description: ${firstDay.description}'),
                      Text('Duration: ${firstDay.totalDurationMinutes} minutes'),
                      Text('Segments: ${firstDay.segments?.length ?? 0}'),
                      const SizedBox(height: 8),
                      const Text('Pattern:', style: TextStyle(fontWeight: FontWeight.w500)),
                      if (firstDay.segments != null && firstDay.segments!.isNotEmpty) ...[
                        Text('${firstDay.segments![0].durationMinutes}min walk → ${firstDay.segments![1].durationMinutes}min run → repeat'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Final Training Day Preview
            if (lastDay != null && lastDay.isTrainingDay) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Final Achievement',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Week ${lastDay.weekNumber}, Day ${lastDay.dayNumber}'),
                      Text('Description: ${lastDay.description}'),
                      Text('Duration: ${lastDay.totalDurationMinutes} minutes'),
                      if (lastDay.segments != null) ...[
                        const Text('30 minutes of continuous running! 🏃‍♀️🏃‍♂️'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Start Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to week selection or start training
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Training program coming soon! 🏃‍♀️'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text(
                  'Start Your Running Journey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
