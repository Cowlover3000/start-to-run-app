import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const StartToRunApp());
}

class StartToRunApp extends StatelessWidget {
  const StartToRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start to Run',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('nl', ''),
      ],
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Simple state management for the running program
  int currentWeek = 3;
  int currentDay = 1;
  bool isTrainingDay = true;
  String todayDescription = "Mix of 90s runs and 90s walks";
  String weekTitle = "Week 3 - Building Endurance";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.phone_android, color: Colors.black),
            const SizedBox(width: 8),
            const Text(
              'Home Screen',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress Circle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: currentWeek / 9, // Assuming 9 week program
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Week $currentWeek',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Day $currentDay',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Week Description
              Text(
                weekTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                todayDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Training Day Card
              if (isTrainingDay) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Vandaag',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Trainingsdag',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextButton(
                          onPressed: () => _startTraining(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Start Training',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Rest Day Tomorrow
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Morgen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rustdag',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Neem een welverdiende pauze!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Voltooid', '${(currentWeek - 1) * 3 + currentDay - 1}', Icons.check_circle),
                  _buildStatCard('Week', '$currentWeek/9', Icons.calendar_today),
                  _buildStatCard('Dag', '$currentDay', Icons.today),
                ],
              ),
              
              const SizedBox(height: 16), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey[600], size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _startTraining() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Training Starten'),
          content: Text('Start je training voor $weekTitle!\n\n$todayDescription'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _completeTraining();
              },
              child: const Text('Start!'),
            ),
          ],
        );
      },
    );
  }
  
  void _completeTraining() {
    setState(() {
      if (currentDay < 3) {
        currentDay++;
        isTrainingDay = currentDay % 2 == 1; // Training on odd days
      } else {
        currentWeek++;
        currentDay = 1;
        isTrainingDay = true;
        // Update week title and description based on week
        weekTitle = "Week $currentWeek - ${_getWeekTitle(currentWeek)}";
        todayDescription = _getWeekDescription(currentWeek);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Training voltooid! Goed gedaan!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  String _getWeekTitle(int week) {
    switch (week) {
      case 1: return "Starting Easy";
      case 2: return "Building Base";
      case 3: return "Building Endurance";
      case 4: return "Increasing Duration";
      case 5: return "Building Stamina";
      case 6: return "Longer Runs";
      case 7: return "Extended Training";
      case 8: return "Final Preparation";
      case 9: return "Achievement Week";
      default: return "Continuing Journey";
    }
  }
  
  String _getWeekDescription(int week) {
    switch (week) {
      case 1: return "1 min run, 90s walk intervals";
      case 2: return "90s run, 2 min walk intervals";
      case 3: return "Mix of 90s runs and 90s walks";
      case 4: return "3 min run, 90s walk intervals";
      case 5: return "5 min run, 90s walk intervals";
      case 6: return "8 min run, 90s walk intervals";
      case 7: return "15 min continuous running";
      case 8: return "20 min continuous running";
      case 9: return "30 min continuous running";
      default: return "Keep running and improving!";
    }
  }
}
