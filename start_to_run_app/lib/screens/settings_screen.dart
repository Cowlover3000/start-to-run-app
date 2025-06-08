import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          // User Profile Section
          _buildSection(
            title: 'Profiel',
            children: [
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'Persoonlijke gegevens',
                subtitle: 'Naam, leeftijd, gewicht bewerken',
                onTap: () {
                  // TODO: Navigate to profile screen
                },
              ),
              _buildSettingsTile(
                icon: Icons.fitness_center,
                title: 'Trainingsdoelen',
                subtitle: 'Stel je loopafstand en tempo in',
                onTap: () {
                  // TODO: Navigate to goals screen
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Training Settings Section
          _buildSection(
            title: 'Training',
            children: [
              _buildSwitchTile(
                icon: Icons.volume_up_outlined,
                title: 'Audio coaching',
                subtitle: 'Ontvang spraakbegeleiding tijdens training',
                value: true,
                onChanged: (value) {
                  // TODO: Update audio coaching setting
                },
              ),
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Trainingsherinneringen',
                subtitle: 'Dagelijkse meldingen voor trainingen',
                value: true,
                onChanged: (value) {
                  // TODO: Update notification setting
                },
              ),
              _buildSwitchTile(
                icon: Icons.location_on_outlined,
                title: 'GPS tracking',
                subtitle: 'Volg je route en afstand',
                value: false,
                onChanged: (value) {
                  // TODO: Update GPS setting
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
                icon: Icons.language_outlined,
                title: 'Taal',
                subtitle: 'Nederlands',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to language selection
                },
              ),
              _buildSettingsTile(
                icon: Icons.backup_outlined,
                title: 'Data backup',
                subtitle: 'Synchroniseer je voortgang',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to backup settings
                },
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Ondersteuning',
                subtitle: 'Veelgestelde vragen en contact',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help screen
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
          child: Column(
            children: children,
          ),
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
        child: Icon(
          icon,
          color: Colors.grey.shade700,
          size: 20,
        ),
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
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: trailing,
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
        child: Icon(
          icon,
          color: Colors.grey.shade700,
          size: 20,
        ),
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
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4CAF50),
      ),
    );
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
              onPressed: () {
                // TODO: Reset progress logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voortgang is gereset'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
