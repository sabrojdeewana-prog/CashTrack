import 'package:flutter/material.dart';
import 'admin_panel_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin Panel'),
            subtitle: const Text('Open secure web admin dashboard'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen())),
          ),
          const ListTile(
            leading: Icon(Icons.storage),
            title: Text('Local Storage'),
            subtitle: Text('Your transactions stay on this device.'),
          ),
        ],
      ),
    );
  }
}
