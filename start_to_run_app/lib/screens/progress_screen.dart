import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  value: '15',
                  color: const Color(0xFF4CAF50),
                ),
                _buildMetricCard(
                  title: 'Beste Hardloop\nTijd',
                  value: '5:23',
                  color: const Color(0xFF2196F3),
                ),
                _buildMetricCard(
                  title: 'Succes\nPercentage',
                  value: '87%',
                  color: const Color(0xFFFF9800),
                ),
                _buildMetricCard(
                  title: 'Huidige\nWeek',
                  value: '3',
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
                final isCurrentWeek = weekNumber == 3; // Week 3 is current
                
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 40 - 24) / 3, // 3 buttons per row with spacing
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to week details or update current week
                      print('Week $weekNumber selected');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentWeek 
                          ? const Color(0xFF4CAF50) 
                          : Colors.white,
                      foregroundColor: isCurrentWeek 
                          ? Colors.white 
                          : Colors.black87,
                      elevation: isCurrentWeek ? 4 : 2,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isCurrentWeek 
                              ? const Color(0xFF4CAF50) 
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Week $weekNumber',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrentWeek 
                            ? FontWeight.bold 
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
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
