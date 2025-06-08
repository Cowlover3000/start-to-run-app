import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_data_provider.dart';
import '../providers/training_session_provider.dart';
import '../models/training_program.dart';

class ActiveTrainingScreen extends StatefulWidget {
  const ActiveTrainingScreen({super.key});

  @override
  State<ActiveTrainingScreen> createState() => _ActiveTrainingScreenState();
}

class _ActiveTrainingScreenState extends State<ActiveTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TrainingDataProvider, TrainingSessionProvider>(
      builder: (context, trainingData, sessionProvider, child) {
        // Check if session was just completed
        if (sessionProvider.sessionStatus == SessionStatus.completed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showCompletionDialog(context, trainingData, sessionProvider);
          });
        }

        final currentTrainingDay = trainingData.currentTrainingDay;
        
        // If there's no training day or it's a rest day, show a message
        if (currentTrainingDay == null || !currentTrainingDay.isTrainingDay) {
          return Scaffold(
            backgroundColor: const Color(0xFF4A90E2),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.self_improvement,
                      color: Colors.white,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Vandaag is een rustdag!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentTrainingDay?.description ?? 'Neem een welverdiende pauze!',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4A90E2),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Terug naar Home'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final segments = currentTrainingDay.segments ?? [];
        final currentSegmentIndex = sessionProvider.currentSegmentIndex;
        final currentSegment = currentSegmentIndex < segments.length 
            ? segments[currentSegmentIndex] 
            : null;
        
        // Calculate next segment
        final nextSegmentIndex = currentSegmentIndex + 1;
        final nextSegment = nextSegmentIndex < segments.length 
            ? segments[nextSegmentIndex] 
            : null;

        return Scaffold(
          backgroundColor: const Color(0xFF4A90E2), // Blue background matching UX design
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Information Section
                  Column(
                    children: [
                      Text(
                        'Week ${trainingData.currentWeek}, Dag ${trainingData.currentDay}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Activiteit ${currentSegmentIndex + 1} van ${segments.length}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  // Current Activity and Timer Section
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Current Activity Display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5BA3F5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                currentSegment?.type == ActivityType.running 
                                    ? Icons.directions_run 
                                    : Icons.directions_walk,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                currentSegment?.type == ActivityType.running 
                                    ? 'HARDLOPEN' 
                                    : 'WANDELEN',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Main Timer Display
                        Text(
                          _formatTime(sessionProvider.remainingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Next Activity Info
                        if (nextSegment != null) 
                          Text(
                            'Daarna: ${nextSegment.type == ActivityType.running ? 'Hardlopen' : 'Wandelen'} (${nextSegment.durationMinutes} minuten)',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          )
                        else
                          const Text(
                            'Laatste activiteit!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                  
                  // Bottom Section - Time Info and Controls
                  Column(
                    children: [
                      // Total Time and Remaining Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Totale Tijd',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(sessionProvider.elapsedTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Resterend',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trainingData.formatDuration(currentTrainingDay.totalDurationMinutes ?? 0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Pause/Resume Button
                          Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107), // Yellow color
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (sessionProvider.isRunning) {
                                  sessionProvider.pauseSession();
                                } else {
                                  sessionProvider.resumeSession();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    sessionProvider.isRunning ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      sessionProvider.isRunning ? 'Pauze' : 'Hervat',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Stop Button
                          Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5252), // Red color
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                sessionProvider.stopSession();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Stop',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showCompletionDialog(BuildContext context, TrainingDataProvider trainingData, TrainingSessionProvider sessionProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Congratulations Message
                const Text(
                  'Gefeliciteerd!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Je hebt Week ${trainingData.currentWeek}, Dag ${trainingData.currentDay} voltooid!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Training Time
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timer,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Trainingstijd: ${_formatTime(sessionProvider.elapsedTime)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Progress Info
                Text(
                  'Je voortgang is opgeslagen!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      sessionProvider.stopSession(); // Reset session
                      Navigator.of(context).pop(); // Go back to main screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ga verder',
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
        );
      },
    );
  }
}
