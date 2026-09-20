import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_panel_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String supportEmail = 'Sabrojalam54321@gmail.com';

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About CashTrack'),
        content: const SingleChildScrollView(
          child: Text(
            'CashTrack - Daily Expense Manager\n\n'
            'CashTrack is a simple personal finance app designed to help you '
            'track income, expenses, transactions and manage your daily money.\n\n'
            'Your transaction data is stored locally on your device. '
            'Use the Reports, Calculator and other available tools to manage '
            'your finances more easily.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms & Conditions\n\n'
            '1. Acceptance\n'
            'By using CashTrack, you agree to use the application responsibly '
            'and in accordance with these terms.\n\n'
            '2. Personal Use\n'
            'CashTrack is intended for personal financial record keeping. '
            'You are responsible for the accuracy of the information you enter.\n\n'
            '3. Financial Information\n'
            'CashTrack is a tracking and calculation tool. It does not provide '
            'financial, investment, tax, legal or professional advice. '
            'Always verify important financial decisions independently.\n\n'
            '4. Data\n'
            'Transaction information may be stored locally on your device. '
            'You are responsible for maintaining access to your device and '
            'keeping your information secure.\n\n'
            '5. Calculations\n'
            'Calculator, EMI, interest, GST and other results are provided '
            'for informational purposes. Verify important calculations before '
            'making financial decisions.\n\n'
            '6. Availability\n'
            'We may update, modify or improve CashTrack features from time to '
            'time. Features may change without prior notice.\n\n'
            '7. Limitation of Liability\n'
            'CashTrack and its developers are not responsible for financial '
            'losses, decisions or damages resulting from reliance on information '
            'or calculations provided by the app.\n\n'
            '8. Contact\n'
            'For questions or support, contact us at:\n'
            'Sabrojalam54321@gmail.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contact & Support'),
        content: const Text(
          'For support, feedback or questions, contact us at:\n\n'
          'Sabrojalam54321@gmail.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return ListView(
            children: [
              if (user != null) ...[
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(user.displayName ?? 'User'),
                  subtitle: Text(user.email ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin Dashboard'),
                subtitle: const Text('Open admin dashboard'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminPanelScreen(),
                    ),
                  );
                },
              ),
              const ListTile(
                leading: Icon(Icons.storage),
                title: Text('Local Storage'),
                subtitle: Text(
                  'Your transactions stay on this device.',
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About CashTrack'),
                subtitle: const Text('About the app and its features'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAbout(context),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Terms & Conditions'),
                subtitle: const Text('Read the terms of using CashTrack'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTerms(context),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Contact & Support'),
                subtitle: Text(supportEmail),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showContact(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
