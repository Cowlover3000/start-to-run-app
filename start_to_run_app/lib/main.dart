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

/// Simple loading screen shown while data is being loaded
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
            SizedBox(height: 24),
            Text(
              'Start to Run',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Je trainingsdata wordt geladen...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final provider = TrainingDataProvider();
            // Load saved progress on app startup
            provider.loadProgress();
            return provider;
          },
        ),
        ChangeNotifierProxyProvider2<
          TrainingDataProvider,
          SettingsProvider,
          TrainingSessionProvider
        >(
          create: (context) => TrainingSessionProvider(),
          update:
              (
                context,
                trainingDataProvider,
                settingsProvider,
                trainingSessionProvider,
              ) {
                trainingSessionProvider?.setTrainingDataProvider(
                  trainingDataProvider,
                );
                trainingSessionProvider?.updateFeedbackSettings(
                  soundEnabled: settingsProvider.soundSignals,
                  hapticEnabled: settingsProvider.hapticFeedback,
                );
                return trainingSessionProvider!;
              },
        ),
      ],
      child: Consumer<TrainingDataProvider>(
        builder: (context, trainingData, child) {
          // Show loading screen until data is loaded
          if (!trainingData.isLoaded) {
            return MaterialApp(
              title: 'Start to Run',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                useMaterial3: true,
              ),
              home: const LoadingScreen(),
            );
          }

          return MaterialApp(
            title: 'Start to Run',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
              useMaterial3: true,
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
