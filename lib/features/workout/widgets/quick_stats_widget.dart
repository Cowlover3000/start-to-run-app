import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        final completedWorkouts = workoutProvider.completedWorkouts;
        final totalWorkouts = workoutProvider.workouts.length;
        final completedThisWeek = _getCompletedThisWeek(completedWorkouts);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                l10n.weeklyGoal,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Icons.check_circle,
                    label: l10n.completed,
                    value: completedWorkouts.length.toString(),
                  ),
                  _StatItem(
                    icon: Icons.trending_up,
                    label: 'Deze week',
                    value: completedThisWeek.toString(),
                  ),
                  _StatItem(
                    icon: Icons.fitness_center,
                    label: 'Totaal',
                    value: totalWorkouts.toString(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  int _getCompletedThisWeek(List<dynamic> completedWorkouts) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return completedWorkouts.where((workout) {
      if (workout.completedAt == null) return false;
      final completedDate = workout.completedAt!;
      return completedDate.isAfter(startOfWeek) && 
             completedDate.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).length;
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
