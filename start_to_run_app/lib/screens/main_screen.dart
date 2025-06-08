import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_data_provider.dart';
import '../providers/training_session_provider.dart';
import 'active_training_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void switchToHome() {
    setState(() {
      _currentIndex = 0; // Home screen index
    });
  }

  void switchToTraining() {
    // Training is now handled through focused experience, no tab switching needed
    // The training screen will be shown automatically when training is active
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingSessionProvider>(
      builder: (context, sessionProvider, child) {
        final isTrainingActive = sessionProvider.sessionStatus == SessionStatus.inProgress || 
                                 sessionProvider.sessionStatus == SessionStatus.paused;
        
        final List<Widget> screens = [
          HomePage(onStartTraining: switchToTraining),
          const ProgressScreen(),
          const SettingsScreen(),
        ];

        // If training is active, force the user to stay on the training screen
        // and hide the navigation bar to create a focused experience
        if (isTrainingActive) {
          return Scaffold(
            body: ActiveTrainingScreen(onStopTraining: switchToHome),
          );
        }

        // Normal navigation when training is not active
        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: screens),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF4CAF50),
            unselectedItemColor: Colors.grey.shade600,
            backgroundColor: Colors.white,
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_outlined),
                activeIcon: Icon(Icons.trending_up),
                label: 'Voortgang',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Instellingen',
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onStartTraining;

  const HomePage({super.key, required this.onStartTraining});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingDataProvider>(
      builder: (context, trainingData, child) {
        final currentTrainingDay = trainingData.currentTrainingDay;
        final nextTrainingDay = trainingData.nextTrainingDay;
        final currentWeek = trainingData.currentWeek;
        final currentDay = trainingData.currentDay;
        final weekProgress = trainingData.currentWeekProgress;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Section - Week/Day & Progress Indicator
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: weekProgress,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4CAF50),
                            ),
                            strokeWidth: 6,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Week $currentWeek',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Week description
                  Text(
                    _getWeekDescription(currentWeek),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _getWeekSubtitle(currentWeek),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Current Day Card
                  if (currentTrainingDay != null &&
                      currentTrainingDay.isTrainingDay) ...[
                    // Today's Training Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Trainingsdag',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentTrainingDay.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (currentTrainingDay.totalDurationMinutes !=
                              null) ...[
                            const SizedBox(height: 4),
                            Text(
                              trainingData.formatDuration(
                                currentTrainingDay.totalDurationMinutes!,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Initialize session with current training data
                                final sessionProvider =
                                    Provider.of<TrainingSessionProvider>(
                                      context,
                                      listen: false,
                                    );
                                sessionProvider.selectDay(
                                  currentWeek,
                                  currentDay,
                                );
                                sessionProvider.startSession();
                                widget.onStartTraining();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFF5252),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
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
                  ] else if (currentTrainingDay != null &&
                      currentTrainingDay.isRestDay) ...[
                    // Today's Rest Day Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            trainingData.getDayType(currentWeek, currentDay),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Rustdag',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentTrainingDay.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Progress Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${trainingData.completedTrainingDays}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                                Text(
                                  'Trainingen voltooid',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${((trainingData.overallProgress) * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                                Text(
                                  'Programma voltooid',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Next Training Day Preview (if today is rest day)
                  if (currentTrainingDay != null &&
                      currentTrainingDay.isRestDay &&
                      nextTrainingDay != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Volgende training',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Week ${nextTrainingDay.weekNumber}, ${trainingData.getDayType(nextTrainingDay.weekNumber, nextTrainingDay.dayNumber)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            nextTrainingDay.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getWeekDescription(int week) {
    switch (week) {
      case 1:
        return 'Week 1 - Eerste stappen';
      case 2:
        return 'Week 2 - Langere intervallen';
      case 3:
        return 'Week 3 - Uithoudingsvermogen';
      case 4:
        return 'Week 4 - Stamina opbouwen';
      case 5:
        return 'Week 5 - Doorlopend hardlopen';
      case 6:
        return 'Week 6 - Langere sessies';
      case 7:
        return 'Week 7 - Meer kilometers';
      case 8:
        return 'Week 8 - Grote mijlpaal';
      case 9:
        return 'Week 9 - Bijna daar';
      case 10:
        return 'Week 10 - Finale week';
      default:
        return 'Week $week';
    }
  }

  String _getWeekSubtitle(int week) {
    switch (week) {
      case 1:
        return 'Alterneren tussen 1 min hardlopen en 2 min wandelen';
      case 2:
        return 'Langere hardloopintervallen van 2 minuten';
      case 3:
        return 'Opbouwen naar 3 minuten hardlopen';
      case 4:
        return 'Uitgebreide 5-minuten hardloopsessies';
      case 5:
        return 'Begin van 8-minuten doorlopend hardlopen';
      case 6:
        return '10 minuten aaneengesloten hardlopen';
      case 7:
        return 'Opbouwen naar 15-20 minuten hardlopen';
      case 8:
        return '20+ minuten doorlopend hardlopen';
      case 9:
        return '25 minuten non-stop hardlopen';
      case 10:
        return '30 minuten doorlopend hardlopen - je bent nu een hardloper!';
      default:
        return 'Ga verder met je hardlooptraject';
    }
  }
}
