import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_data_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingDataProvider>(
      builder: (context, trainingData, child) {
        final stats = trainingData.getProgressStats();
        
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Voortgang',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Metrics Section
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMetricCard(
                      title: 'Trainingen\nVoltooid',
                      value: '${stats['completedTrainingDays']}',
                      color: const Color(0xFF4CAF50),
                    ),
                    _buildMetricCard(
                      title: 'Programma\nVoortgang',
                      value: '${(stats['overallProgress'] * 100).round()}%',
                      color: const Color(0xFF2196F3),
                    ),
                    _buildMetricCard(
                      title: 'Huidige\nReeks',
                      value: '${stats['currentStreak']}',
                      color: const Color(0xFFFF9800),
                    ),
                    _buildMetricCard(
                      title: 'Huidige\nWeek',
                      value: '${stats['currentWeek']}',
                      color: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Programma Voortgang Title
                const Text(
                  'Programma Voortgang',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Week Navigation Buttons
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(10, (index) {
                    final weekNumber = index + 1;
                    final isCurrentWeek = weekNumber == trainingData.currentWeek;
                    final isCompletedWeek = weekNumber < trainingData.currentWeek;
                    
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 40 - 24) / 3, // 3 buttons per row with spacing
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the selected week
                          trainingData.goToWeek(weekNumber);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Navigated to Week $weekNumber'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrentWeek 
                              ? const Color(0xFF4CAF50) 
                              : isCompletedWeek
                                  ? const Color(0xFF81C784)
                                  : Colors.white,
                          foregroundColor: isCurrentWeek || isCompletedWeek
                              ? Colors.white 
                              : Colors.black87,
                          elevation: isCurrentWeek ? 4 : 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isCurrentWeek 
                                  ? const Color(0xFF4CAF50) 
                                  : isCompletedWeek
                                      ? const Color(0xFF81C784)
                                      : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Week $weekNumber',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isCurrentWeek 
                                    ? FontWeight.bold 
                                    : FontWeight.w500,
                              ),
                            ),
                            if (isCompletedWeek) ...[
                              const SizedBox(height: 2),
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                
                const SizedBox(height: 32),
                
                // Weekly Progress Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week ${trainingData.currentWeek} Voortgang',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: trainingData.currentWeekProgress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${trainingData.completedTrainingDaysThisWeek}/${trainingData.totalTrainingDaysThisWeek} trainingen voltooid',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '${(trainingData.currentWeekProgress * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
