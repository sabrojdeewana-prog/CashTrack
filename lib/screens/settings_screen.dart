import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_panel_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            ],
          );
        },
      ),
    );
  }
}
