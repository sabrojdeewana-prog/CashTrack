import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  static const String adminEmail = 'Sabrojalam54321@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: const Icon(Icons.admin_panel_settings, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Administrator',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          adminEmail,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Admin Access',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          _adminCard(
            icon: Icons.dashboard,
            title: 'Dashboard Overview',
            subtitle: 'App activity and important statistics',
          ),

          _adminCard(
            icon: Icons.people,
            title: 'Users',
            subtitle: 'View and manage app users',
          ),

          _adminCard(
            icon: Icons.analytics,
            title: 'Analytics',
            subtitle: 'App usage and activity statistics',
          ),

          _adminCard(
            icon: Icons.receipt_long,
            title: 'Transactions',
            subtitle: 'View transaction activity',
          ),

          _adminCard(
            icon: Icons.download,
            title: 'Reports & Downloads',
            subtitle: 'Monitor report generation and downloads',
          ),

          _adminCard(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage app notifications and reminders',
          ),

          _adminCard(
            icon: Icons.settings,
            title: 'App Settings',
            subtitle: 'Manage application configuration',
          ),

          _adminCard(
            icon: Icons.security,
            title: 'Security',
            subtitle: 'Admin access and security settings',
          ),
        ],
      ),
    );
  }

  static Widget _adminCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
