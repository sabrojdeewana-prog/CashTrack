import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/firebase_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});
  @override State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late final WebViewController controller;

  // Replace this with YOUR authenticated admin web dashboard URL.
  // Do not put Firebase Console credentials or private keys in the APK.
  static const adminUrl = 'https://example.com/admin';

  @override
  void initState() {
    super.initState();
    FirebaseService.adminPanelOpened();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(adminUrl));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin Panel')),
    body: const _AdminWarning(),
  );
}

class _AdminWarning extends StatelessWidget {
  const _AdminWarning();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Configure adminUrl in admin_panel_screen.dart with your authenticated admin dashboard URL before release.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
