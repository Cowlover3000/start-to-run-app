import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_session_provider.dart';
import '../models/training_program.dart';

class TrainingSessionScreen extends StatefulWidget {
  const TrainingSessionScreen({super.key});

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Session'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<TrainingSessionProvider>(
        builder: (context, provider, child) {
          final currentDay = provider.currentDay;
          
          if (currentDay == null || currentDay.isRestDay) {
            return _buildRestDayView(context, provider);
          }
          
          return _buildTrainingDayView(context, provider, currentDay);
        },
      ),
    );
  }
  
  Widget _buildRestDayView(BuildContext context, TrainingSessionProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Rest Day',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Week ${provider.currentWeek}, Day ${provider.currentDayInWeek}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Take a well-deserved break! Rest days are crucial for recovery and preventing injury.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            _buildNavigationButtons(context, provider),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTrainingDayView(BuildContext context, TrainingSessionProvider provider, TrainingDay day) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSessionHeader(context, provider, day),
          const SizedBox(height: 24),
          _buildCurrentSegmentCard(context, provider),
          const SizedBox(height: 16),
          _buildProgressIndicator(context, provider),
          const SizedBox(height: 24),
          _buildSessionControls(context, provider),
          const SizedBox(height: 24),
          _buildSegmentsList(context, provider, day),
          const SizedBox(height: 24),
          _buildNavigationButtons(context, provider),
        ],
      ),
    );
  }
  
  Widget _buildSessionHeader(BuildContext context, TrainingSessionProvider provider, TrainingDay day) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Week ${provider.currentWeek}, Day ${provider.currentDayInWeek}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildSessionStatusBadge(context, provider),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total Duration: ${provider.getFormattedTime(provider.totalSessionDuration)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${day.segments?.length ?? 0} segments',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSessionStatusBadge(BuildContext context, TrainingSessionProvider provider) {
    final status = provider.sessionStatus;
    Color backgroundColor;
    Color textColor;
    String label;
    
    switch (status) {
      case SessionStatus.notStarted:
        backgroundColor = Theme.of(context).colorScheme.surfaceVariant;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        label = 'Not Started';
        break;
      case SessionStatus.inProgress:
        backgroundColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        label = 'In Progress';
        break;
      case SessionStatus.paused:
        backgroundColor = Theme.of(context).colorScheme.tertiary;
        textColor = Theme.of(context).colorScheme.onTertiary;
        label = 'Paused';
        break;
      case SessionStatus.completed:
        backgroundColor = Theme.of(context).colorScheme.secondary;
        textColor = Theme.of(context).colorScheme.onSecondary;
        label = 'Completed';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
  
  Widget _buildCurrentSegmentCard(BuildContext context, TrainingSessionProvider provider) {
    final segment = provider.currentSegment;
    if (segment == null) return const SizedBox.shrink();
    
    final isRunning = segment.type == ActivityType.running;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isRunning ? Icons.directions_run : Icons.directions_walk,
                  size: 48,
                  color: isRunning 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Segment ${provider.currentSegmentIndex + 1}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        isRunning ? 'Running' : 'Walking',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Duration: ${provider.getFormattedTime(segment.durationSeconds)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (provider.sessionStatus == SessionStatus.inProgress) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Elapsed: ${provider.getFormattedTime(provider.elapsedTime)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Remaining: ${provider.getFormattedTime(provider.currentSegmentRemainingTime)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator(BuildContext context, TrainingSessionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Session Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${provider.currentSegmentIndex + 1} / ${provider.currentDay?.segments?.length ?? 0}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: provider.sessionProgress,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSessionControls(BuildContext context, TrainingSessionProvider provider) {
    final status = provider.sessionStatus;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (status == SessionStatus.notStarted)
          FilledButton.icon(
            onPressed: () => provider.startSession(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
          ),
        
        if (status == SessionStatus.inProgress) ...[
          ElevatedButton.icon(
            onPressed: () => provider.pauseSession(),
            icon: const Icon(Icons.pause),
            label: const Text('Pause'),
          ),
          FilledButton.icon(
            onPressed: provider.hasNextSegment 
              ? () => provider.nextSegment()
              : () => provider.completeSession(),
            icon: Icon(provider.hasNextSegment ? Icons.skip_next : Icons.check),
            label: Text(provider.hasNextSegment ? 'Next Segment' : 'Complete'),
          ),
        ],
        
        if (status == SessionStatus.paused) ...[
          FilledButton.icon(
            onPressed: () => provider.resumeSession(),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Resume'),
          ),
          ElevatedButton.icon(
            onPressed: () => provider.stopSession(),
            icon: const Icon(Icons.stop),
            label: const Text('Stop'),
          ),
        ],
        
        if (status == SessionStatus.completed)
          FilledButton.icon(
            onPressed: () => provider.stopSession(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Session'),
          ),
      ],
    );
  }
  
  Widget _buildSegmentsList(BuildContext context, TrainingSessionProvider provider, TrainingDay day) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Segments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(day.segments?.asMap().entries.map((entry) {
              final index = entry.key;
              final segment = entry.value;
              final isCurrentSegment = index == provider.currentSegmentIndex;
              final isCompleted = index < provider.currentSegmentIndex;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrentSegment 
                    ? Theme.of(context).colorScheme.primaryContainer
                    : isCompleted
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrentSegment
                    ? Border.all(color: Theme.of(context).colorScheme.primary)
                    : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted 
                        ? Icons.check_circle
                        : segment.type == ActivityType.running
                          ? Icons.directions_run
                          : Icons.directions_walk,
                      color: isCompleted
                        ? Theme.of(context).colorScheme.secondary
                        : segment.type == ActivityType.running
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${index + 1}. ${segment.type == ActivityType.running ? 'Run' : 'Walk'} for ${provider.getFormattedTime(segment.durationSeconds)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isCurrentSegment ? FontWeight.bold : null,
                          color: isCurrentSegment 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }) ?? []),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavigationButtons(BuildContext context, TrainingSessionProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: provider.currentWeek > 1 || provider.currentDayInWeek > 1
            ? () => provider.previousDay()
            : null,
          icon: const Icon(Icons.chevron_left),
          label: const Text('Previous Day'),
        ),
        ElevatedButton.icon(
          onPressed: provider.currentWeek < 10 || provider.currentDayInWeek < 7
            ? () => provider.nextDay()
            : null,
          icon: const Icon(Icons.chevron_right),
          label: const Text('Next Day'),
        ),
      ],
    );
  }
}
