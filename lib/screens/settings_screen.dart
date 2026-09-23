import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_panel_screen.dart';
import '../database/database_helper.dart';
import '../services/app_lock_service.dart';
import '../services/backup_service.dart';
import '../services/csv_service.dart';
import '../services/pdf_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _appLockEnabled = false;
  bool _loadingLock = true;
  bool _busy = false;

  static const String supportEmail = 'Sabrojalam54321@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadAppLock();
  }

  Future<void> _loadAppLock() async {
    final enabled = await AppLockService.isEnabled();

    if (!mounted) return;

    setState(() {
      _appLockEnabled = enabled;
      _loadingLock = false;
    });
  }

  Future<void> _toggleAppLock(bool value) async {
    final authenticated = await AppLockService.authenticate();

    if (!authenticated) return;

    if (value) {
      await AppLockService.enable();
    } else {
      await AppLockService.disable();
    }

    if (!mounted) return;

    setState(() {
      _appLockEnabled = value;
    });

    _showMessage(
      value ? 'App Lock enabled.' : 'App Lock disabled.',
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _backup() async {
    if (_busy) return;

    setState(() => _busy = true);

    try {
      final success = await BackupService.exportBackup();

      if (success) {
        _showMessage('Backup saved successfully.');
      }
    } catch (e) {
      _showMessage('Backup failed: $e');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _restore() async {
    if (_busy) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restore Backup?'),
          content: const Text(
            'Restoring a backup will replace your current transactions '
            'with the transactions from the selected backup file.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _busy = true);

    try {
      final count = await BackupService.restoreBackup();

      if (count != null) {
        _showMessage('$count transactions restored successfully.');
      }
    } catch (e) {
      _showMessage('Restore failed: $e');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _exportCsv() async {
    if (_busy) return;

    setState(() => _busy = true);

    try {
      final transactions = await DatabaseHelper.instance.getAll();
      final success = await CsvService.export(transactions);

      if (success) {
        _showMessage('CSV report saved successfully.');
      }
    } catch (e) {
      _showMessage('CSV export failed: $e');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _exportPdf() async {
    if (_busy) return;

    setState(() => _busy = true);

    try {
      final transactions = await DatabaseHelper.instance.getAll();

      await PdfService.createAndPrint(
        transactions,
        title: 'CashTrack Financial Report',
      );

      _showMessage('PDF report is ready to share.');
    } catch (e) {
      _showMessage('PDF export failed: $e');
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _showPremium() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final benefits = [
          'Advanced expense management',
          'Unlimited transaction records',
          'Detailed financial reports',
          'PDF and CSV export tools',
          'Backup and restore tools',
          'Smart Calculator tools',
          'Premium experience with future features',
          'Priority access to new premium features',
        ];

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.workspace_premium,
                      size: 58,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'CashTrack Premium',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Get more tools and a better money-management experience.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Premium Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...benefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 21,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              benefit,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _planTile(
                    context: sheetContext,
                    title: 'Monthly Plan',
                    price: '₹99 / month',
                    icon: Icons.calendar_month,
                  ),
                  const SizedBox(height: 12),
                  _planTile(
                    context: sheetContext,
                    title: 'Yearly Plan',
                    price: '₹1099 / year',
                    icon: Icons.star,
                    highlighted: true,
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Payment will be connected when a payment provider '
                      'is added to CashTrack.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About CashTrack'),
          content: const SingleChildScrollView(
            child: Text(
              'CashTrack - Daily Expense Manager\n\n'
              'CashTrack is a personal finance management app designed '
              'to help you track income, expenses and transactions.\n\n'
              'Features include transaction management, reports, monthly '
              'overview, smart calculator, backup and restore, PDF/CSV '
              'export and device security.\n\n'
              'Your transaction records are stored locally on your device.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacy() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Privacy Policy\n\n'
              'CashTrack is designed to keep your personal transaction '
              'records on your device.\n\n'
              'Transaction data entered into the app is stored locally '
              'for the app to provide its financial tracking features.\n\n'
              'You are responsible for keeping your device secure and '
              'for maintaining backups of important information.\n\n'
              'If you use online features such as account authentication, '
              'those services may process information according to their '
              'respective policies.\n\n'
              'For questions about privacy, contact:\n'
              'Sabrojalam54321@gmail.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Terms & Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms & Conditions\n\n'
              '1. Acceptance\n'
              'By using CashTrack, you agree to use the application '
              'responsibly.\n\n'
              '2. Personal Use\n'
              'CashTrack is intended for personal financial record keeping. '
              'You are responsible for the accuracy of information entered.\n\n'
              '3. Financial Information\n'
              'CashTrack is a tracking and calculation tool and does not '
              'provide financial, investment, tax or legal advice.\n\n'
              '4. Data\n'
              'Transaction information may be stored locally on your device. '
              'You are responsible for maintaining access to your device '
              'and keeping your information secure.\n\n'
              '5. Calculations\n'
              'Calculator, EMI, interest, GST and other results are provided '
              'for informational purposes. Verify important calculations.\n\n'
              '6. Availability\n'
              'Features may be updated, modified or removed from time to time.\n\n'
              '7. Limitation of Liability\n'
              'CashTrack and its developers are not responsible for financial '
              'losses resulting from reliance on information or calculations '
              'provided by the app.\n\n'
              '8. Contact\n'
              'Sabrojalam54321@gmail.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showContact() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.support_agent, color: Colors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text('Feedback & Support'),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need help or want to share feedback?',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.message_outlined),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Support: Sabrojalam54321@gmail.com',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final message = controller.text.trim();

                if (message.isEmpty) {
                  _showMessage('Please write your feedback first.');
                  return;
                }

                final uri = Uri(
                  scheme: 'mailto',
                  path: supportEmail,
                  queryParameters: {
                    'subject': 'CashTrack Feedback',
                    'body': message,
                  },
                );

                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );

                if (launched && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                } else if (mounted) {
                  _showMessage(
                    'No email app found on this device.',
                  );
                }
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Feedback'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _settingTile({
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
      onTap: _busy ? null : onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          if (_busy)
            const LinearProgressIndicator(),

          _sectionTitle('Account'),

          const ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Account'),
            subtitle: Text('Account features are currently unavailable'),
          ),

          _sectionTitle('Admin & Security'),

          _settingTile(
            icon: Icons.admin_panel_settings,
            title: 'Admin Dashboard',
            subtitle: 'Open admin dashboard',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminPanelScreen(),
                ),
              );
            },
          ),

          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: const Text('App Lock'),
            subtitle: Text(
              _loadingLock
                  ? 'Checking security status...'
                  : _appLockEnabled
                      ? 'Protected with device authentication'
                      : 'Protect CashTrack with device security',
            ),
            value: _appLockEnabled,
            onChanged: _loadingLock || _busy
                ? null
                : _toggleAppLock,
          ),

          _sectionTitle('Backup & Export'),

          _settingTile(
            icon: Icons.backup_outlined,
            title: 'Backup Data',
            subtitle: 'Save all transactions as a JSON backup',
            onTap: _backup,
          ),

          _settingTile(
            icon: Icons.restore_outlined,
            title: 'Restore Backup',
            subtitle: 'Restore transactions from a CashTrack backup',
            onTap: _restore,
          ),

          _settingTile(
            icon: Icons.table_chart_outlined,
            title: 'Export CSV',
            subtitle: 'Save your transactions as a CSV report',
            onTap: _exportCsv,
          ),

          _settingTile(
            icon: Icons.picture_as_pdf_outlined,
            title: 'Export PDF',
            subtitle: 'Create and share a PDF financial report',
            onTap: _exportPdf,
          ),

          _sectionTitle('Premium'),

          _settingTile(
            icon: Icons.workspace_premium_outlined,
            title: 'CashTrack Premium',
            subtitle: 'Monthly ₹99 • Yearly ₹1099',
            onTap: _showPremium,
          ),

          _sectionTitle('Information'),

          _settingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read how your data is handled',
            onTap: _showPrivacy,
          ),

          _settingTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read the terms of using CashTrack',
            onTap: _showTerms,
          ),

          _settingTile(
            icon: Icons.info_outline,
            title: 'About CashTrack',
            subtitle: 'About the app and its features',
            onTap: _showAbout,
          ),

          _settingTile(
            icon: Icons.email_outlined,
            title: 'Feedback & Support',
            subtitle: supportEmail,
            onTap: _showContact,
          ),

          const ListTile(
            leading: Icon(Icons.system_update_outlined),
            title: Text('App Version'),
            subtitle: Text('CashTrack 1.0.0'),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
