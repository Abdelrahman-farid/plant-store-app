import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedTheme = 'system'; // 'light', 'dark', 'system'
  bool _notificationsEnabled = true;
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Light Mode'),
                    subtitle: const Text('Always use light theme'),
                    value: 'light',
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() => _selectedTheme = value!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Theme changed to Light Mode'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Always use dark theme'),
                    value: 'dark',
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() => _selectedTheme = value!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Theme changed to Dark Mode'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('System Default'),
                    subtitle: const Text('Use device theme setting'),
                    value: 'system',
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() => _selectedTheme = value!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Theme set to System Default'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Notifications
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive order updates and offers'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() => _notificationsEnabled = value);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Analytics'),
                    subtitle: const Text('Help us improve your experience'),
                    value: _analyticsEnabled,
                    onChanged: (value) {
                      setState(() => _analyticsEnabled = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // General Settings
            Text(
              'General',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: const Text('English'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Privacy & Security'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Clear Cache'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Cache?'),
                          content: const Text(
                            'This will remove saved data and images',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cache cleared'),
                                  ),
                                );
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
