import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/settings_provider.dart';
import '../providers/training_data_provider.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Instellingen',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Training Settings Section
          _buildSection(
            title: 'Training',
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return _buildSwitchTile(
                    icon: Icons.vibration_outlined,
                    title: 'Haptic feedback',
                    subtitle: 'Trillingen voor segmentovergangen',
                    value: settingsProvider.hapticFeedback,
                    onChanged: (value) {
                      settingsProvider.setHapticFeedback(value);
                    },
                  );
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return _buildSwitchTile(
                    icon: Icons.notifications_outlined,
                    title: 'Trainingsherinneringen',
                    subtitle: 'Dagelijkse meldingen voor trainingen',
                    value: settingsProvider.notifications,
                    onChanged: (value) {
                      settingsProvider.setNotifications(value);
                    },
                  );
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return _buildTimeTile(
                    icon: Icons.access_time,
                    title: 'Herinneringstijd',
                    subtitle: 'Tijd voor dagelijkse trainingsherinnering',
                    time: settingsProvider.trainingReminderTime,
                    enabled: settingsProvider.notifications,
                    onTap: settingsProvider.notifications
                        ? () => _selectTime(context)
                        : null,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // App Settings Section
          _buildSection(
            title: 'App',
            children: [
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Test notificatie',
                subtitle: 'Verstuur een test notificatie',
                trailing: const Icon(Icons.send),
                onTap: () async {
                  final notificationService = NotificationService();
                  await notificationService.showTestNotification();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test notificatie verstuurd!'),
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                    );
                  }
                },
              ),
              _buildSettingsTile(
                icon: Icons.timer_outlined,
                title: 'Test herinnering (1 min)',
                subtitle: 'Test over 1 minuut',
                trailing: const Icon(Icons.schedule),
                onTap: () async {
                  final notificationService = NotificationService();
                  final now = DateTime.now();
                  final testTime = now.add(const Duration(minutes: 1));

                  await notificationService.scheduleTestNotification(
                    scheduledTime: testTime,
                    title: 'Test herinnering!',
                    body:
                        'Dit is een test herinnering die over 1 minuut werd gepland.',
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Test herinnering gepland voor ${testTime.hour}:${testTime.minute.toString().padLeft(2, '0')}',
                        ),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  }
                },
              ),
              _buildSettingsTile(
                icon: Icons.info_outlined,
                title: 'Notificatie status',
                subtitle: 'Controleer notificatie instellingen',
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final notificationService = NotificationService();
                  final isEnabled =
                      await notificationService.areNotificationsEnabled() ??
                      false;
                  final canScheduleExact =
                      await notificationService
                          .canScheduleExactNotifications() ??
                      false;
                  final pendingNotifications = await notificationService
                      .getPendingNotifications();

                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Notificatie Status'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Notificaties ingeschakeld: ${isEnabled ? "Ja" : "Nee"}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Exacte alarmen toegestaan: ${canScheduleExact ? "Ja" : "Nee"}',
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Geplande notificaties: ${pendingNotifications.length}',
                              ),
                              const SizedBox(height: 8),
                              if (pendingNotifications.isEmpty)
                                const Text(
                                  'Geen geplande notificaties',
                                  style: TextStyle(color: Colors.grey),
                                )
                              else
                                ...pendingNotifications.map((notification) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '• ID: ${notification.id}\n  ${notification.title}\n  ${notification.body}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }),
                              const SizedBox(height: 16),
                              const Text(
                                'Als notificaties niet werken:\n'
                                '1. Ga naar Android Instellingen\n'
                                '2. Apps → Start to Run\n'
                                '3. Notificaties → Sta alles toe\n'
                                '4. Batterij → Batterijoptimalisatie uitschakelen\n'
                                '5. Speciale app-toegang → Alarms en herinneringen → Toestaan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Sluiten'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              _buildSettingsTile(
                icon: Icons.alarm_outlined,
                title: 'Exacte alarm rechten',
                subtitle: 'Vraag toestemming voor exacte herinneringen',
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final notificationService = NotificationService();

                  // Check current status
                  final canScheduleExact =
                      await notificationService
                          .canScheduleExactNotifications() ??
                      false;

                  if (canScheduleExact) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Exacte alarm rechten zijn al toegestaan!',
                          ),
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                      );
                    }
                  } else {
                    // Request exact alarm permission
                    final androidImplementation = notificationService
                        .flutterLocalNotificationsPlugin
                        .resolvePlatformSpecificImplementation<
                          AndroidFlutterLocalNotificationsPlugin
                        >();
                    if (androidImplementation != null) {
                      final result = await androidImplementation
                          .requestExactAlarmsPermission();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result == true
                                  ? 'Exacte alarm rechten toegestaan!'
                                  : 'Exacte alarm rechten geweigerd. Ga naar Android instellingen om handmatig in te schakelen.',
                            ),
                            backgroundColor: result == true
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF9800),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              _buildSettingsTile(
                icon: Icons.schedule_outlined,
                title: 'Test korte herinnering (30 sec)',
                subtitle: 'Test notificatie over 30 seconden',
                trailing: const Icon(Icons.timer),
                onTap: () async {
                  final notificationService = NotificationService();
                  final now = DateTime.now();
                  final testTime = now.add(const Duration(seconds: 30));

                  await notificationService.scheduleTestNotification(
                    scheduledTime: testTime,
                    title: '30 seconden test! ⏰',
                    body:
                        'Deze test herinnering werd 30 seconden geleden gepland.',
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Test herinnering gepland voor ${testTime.hour}:${testTime.minute.toString().padLeft(2, '0')}:${testTime.second.toString().padLeft(2, '0')}',
                        ),
                        backgroundColor: const Color(0xFF4CAF50),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
              ),
              _buildSettingsTile(
                icon: Icons.language_outlined,
                title: 'Taal',
                subtitle: 'Nederlands',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to language selection
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // About Section
          _buildSection(
            title: 'Over',
            children: [
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'App versie',
                subtitle: '1.0.0',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.article_outlined,
                title: 'Privacybeleid',
                subtitle: 'Lees hoe we je gegevens beschermen',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
              _buildSettingsTile(
                icon: Icons.gavel_outlined,
                title: 'Algemene voorwaarden',
                subtitle: 'Gebruiksvoorwaarden',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open terms of service
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Reset Progress Button
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () {
                _showResetProgressDialog(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Voortgang resetten',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey.shade700, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildTimeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.grey.shade700 : Colors.grey.shade500,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: enabled ? Colors.black87 : Colors.grey.shade500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),
      trailing: Text(
        time.format(context),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: enabled ? Colors.black87 : Colors.grey.shade500,
        ),
      ),
      enabled: enabled,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey.shade700, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: settingsProvider.trainingReminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF4CAF50)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      settingsProvider.setTrainingReminderTime(picked);
    }
  }

  void _showResetProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voortgang resetten'),
          content: const Text(
            'Weet je zeker dat je al je voortgang wilt resetten? Deze actie kan niet ongedaan gemaakt worden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () async {
                final settingsProvider = Provider.of<SettingsProvider>(
                  context,
                  listen: false,
                );
                final trainingDataProvider = Provider.of<TrainingDataProvider>(
                  context,
                  listen: false,
                );

                // Reset both settings and training progress
                await settingsProvider.resetAllData();
                await trainingDataProvider.resetProgress();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alle gegevens zijn gereset'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
