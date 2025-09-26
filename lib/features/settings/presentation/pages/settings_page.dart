import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            title: 'Camera Settings',
            children: [
              _buildSettingsTile(
                icon: Icons.camera_alt,
                title: 'Default Camera Mode',
                subtitle: 'Auto',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.photo_size_select_actual,
                title: 'Photo Resolution',
                subtitle: 'High (12MP)',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.videocam,
                title: 'Video Resolution',
                subtitle: '1080p',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            title: 'Storage',
            children: [
              _buildSettingsTile(
                icon: Icons.storage,
                title: 'Storage Location',
                subtitle: 'Internal Storage',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.auto_delete,
                title: 'Auto Delete',
                subtitle: 'After 30 days',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            title: 'Privacy',
            children: [
              _buildSettingsTile(
                icon: Icons.location_on,
                title: 'Location Tagging',
                subtitle: 'Enabled',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.cloud_upload,
                title: 'Cloud Backup',
                subtitle: 'Disabled',
                onTap: () {},
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSettingsSection(
            title: 'About',
            children: [
              _buildSettingsTile(
                icon: Icons.info,
                title: 'App Version',
                subtitle: '1.0.0',
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help using the app',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}