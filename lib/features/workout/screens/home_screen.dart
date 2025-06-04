import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';
import '../widgets/quick_stats_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 0,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (workoutProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    workoutProvider.errorMessage!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => workoutProvider.loadWorkouts(),
                    child: const Text('Probeer opnieuw'),
                  ),
                ],
              ),
            );
          }

          final pendingWorkouts = workoutProvider.pendingWorkouts;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcome,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                // Quick stats
                const QuickStatsWidget(),
                const SizedBox(height: 24),
                
                // Start workout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: pendingWorkouts.isNotEmpty
                        ? () => _showWorkoutSelector(context, pendingWorkouts)
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.startWorkout),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // My workouts section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.myWorkouts,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to full workouts list
                      },
                      child: const Text('Alle bekijken'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Workouts list
                if (pendingWorkouts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Geen trainingen beschikbaar'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingWorkouts.length > 3 ? 3 : pendingWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = pendingWorkouts[index];
                      return WorkoutCard(
                        workout: workout,
                        onTap: () => _startWorkout(context, workout.id!),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWorkoutSelector(BuildContext context, List<dynamic> workouts) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kies een training',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...workouts.map((workout) => ListTile(
              title: Text(workout.name),
              subtitle: Text('${workout.durationMinutes} min • ${workout.difficulty}'),
              onTap: () {
                Navigator.of(context).pop();
                _startWorkout(context, workout.id!);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, int workoutId) {
    // TODO: Navigate to workout screen
    context.read<WorkoutProvider>().completeWorkout(workoutId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Training gestart!')),
    );
  }
}
