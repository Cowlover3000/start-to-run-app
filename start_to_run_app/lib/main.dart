import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/training_session_provider.dart';
import 'screens/main_screen.dart';
// TODO: Uncomment these imports when implementing additional features
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const StartToRunApp());
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrainingSessionProvider(),
      child: MaterialApp(
        title: 'Start to Run',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

