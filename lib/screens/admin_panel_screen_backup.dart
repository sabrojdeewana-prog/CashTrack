import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  static const String adminEmail = 'Sabrojalam54321@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CashTrack Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _adminHeader(),
          const SizedBox(height: 18),

          _adminCard(
            context,
            Icons.dashboard_rounded,
            'Dashboard Overview',
            'App activity and important statistics',
            const AdminOverviewScreen(),
          ),

          _adminCard(
            context,
            Icons.people_alt_rounded,
            'Users',
            'View and manage app users',
            const AdminUsersScreen(),
          ),

          _adminCard(
            context,
            Icons.analytics_rounded,
            'Analytics',
            'App usage and activity statistics',
            const AdminAnalyticsScreen(),
          ),

          _adminCard(
            context,
            Icons.receipt_long_rounded,
            'Transactions',
            'View transaction activity',
            const AdminTransactionsScreen(),
          ),

          _adminCard(
            context,
            Icons.download_rounded,
            'Reports & Downloads',
            'Monitor report generation and downloads',
            const AdminReportsScreen(),
          ),

          _adminCard(
            context,
            Icons.notifications_active_rounded,
            'Notifications',
            'Manage app notifications and reminders',
            const AdminNotificationsScreen(),
          ),

          _adminCard(
            context,
            Icons.settings_rounded,
            'App Settings',
            'Manage application configuration',
            const AdminSettingsScreen(),
          ),

          _adminCard(
            context,
            Icons.security_rounded,
            'Security',
            'Admin access and security settings',
            const AdminSecurityScreen(),
          ),
        ],
      ),
    );
  }

  Widget _adminHeader() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.admin_panel_settings_rounded,
                size: 34,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Administrator',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    adminEmail,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Admin Access',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 17),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}

class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Dashboard Overview',
      icon: Icons.dashboard_rounded,
      message: 'App activity and important statistics will appear here.',
    );
  }
}

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Users',
      icon: Icons.people_alt_rounded,
      message: 'User management will appear here.',
    );
  }
}

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Analytics',
      icon: Icons.analytics_rounded,
      message: 'App usage and analytics will appear here.',
    );
  }
}

class AdminTransactionsScreen extends StatelessWidget {
  const AdminTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Transactions',
      icon: Icons.receipt_long_rounded,
      message: 'Transaction activity will appear here.',
    );
  }
}

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Reports & Downloads',
      icon: Icons.download_rounded,
      message: 'Report and download activity will appear here.',
    );
  }
}

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Notifications',
      icon: Icons.notifications_active_rounded,
      message: 'Notification management will appear here.',
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'App Settings',
      icon: Icons.settings_rounded,
      message: 'Application settings will appear here.',
    );
  }
}

class AdminSecurityScreen extends StatelessWidget {
  const AdminSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AdminPage(
      title: 'Security',
      icon: Icons.security_rounded,
      message: 'Admin security settings will appear here.',
    );
  }
}

class _AdminPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _AdminPage({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 70),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
