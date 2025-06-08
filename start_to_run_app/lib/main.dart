import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/training_session_provider.dart';
import 'providers/training_data_provider.dart';
import 'providers/settings_provider.dart';
import 'services/notification_service.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  
  runApp(const StartToRunApp());
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => TrainingDataProvider()),
        ChangeNotifierProxyProvider<TrainingDataProvider, TrainingSessionProvider>(
          create: (context) => TrainingSessionProvider(),
          update: (context, trainingDataProvider, trainingSessionProvider) {
            trainingSessionProvider?.setTrainingDataProvider(trainingDataProvider);
            return trainingSessionProvider!;
          },
        ),
      ],
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

