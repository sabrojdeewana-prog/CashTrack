import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  static const Color navy = Color(0xFF172033);
  static const Color blue = Color(0xFF1565C0);
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFDC2626);
  static const Color orange = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF5F7FB);

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<int> _count(String collection) {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'CashTrack Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 400));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(),
            const SizedBox(height: 18),

            const Text(
              'Dashboard Overview',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 12),

            _statsGrid(),

            const SizedBox(height: 24),

            _sectionTitle(
              Icons.people_alt_rounded,
              'Users',
            ),
            _usersSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.receipt_long_rounded,
              'Transactions',
            ),
            _transactionsSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.analytics_rounded,
              'Analytics',
            ),
            _analyticsSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.download_rounded,
              'Reports & Downloads',
            ),
            _downloadsSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.workspace_premium_rounded,
              'Premium',
            ),
            _premiumSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.notifications_active_rounded,
              'Notifications',
            ),
            _notificationsSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.settings_rounded,
              'App Settings',
            ),
            _settingsSection(),

            const SizedBox(height: 22),

            _sectionTitle(
              Icons.security_rounded,
              'Security',
            ),
            _securitySection(),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'CashTrack Admin • Private Dashboard',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: navy,
              size: 34,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Administrator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'sabrojalam54321@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Live Firebase Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 700 ? 4 : 2;

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _liveStat(
              title: 'Total Users',
              icon: Icons.people_alt_rounded,
              color: blue,
              stream: _count('users'),
            ),
            _liveStat(
              title: 'Transactions',
              icon: Icons.receipt_long_rounded,
              color: green,
              stream: _count('transactions'),
            ),
            _liveStat(
              title: 'Downloads',
              icon: Icons.download_rounded,
              color: orange,
              stream: _count('report_downloads'),
            ),
            _liveStat(
              title: 'Premium',
              icon: Icons.workspace_premium_rounded,
              color: red,
              stream: _count('premium_users'),
            ),
          ],
        );
      },
    );
  }

  Widget _liveStat({
    required String title,
    required IconData icon,
    required Color color,
    required Stream<int> stream,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: StreamBuilder<int>(
          stream: stream,
          builder: (context, snapshot) {
            final value = snapshot.hasError
                ? '—'
                : snapshot.hasData
                    ? '${snapshot.data}'
                    : '...';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 27),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
      ],
    );
  }

  Widget _usersSection() {
    return Card(
      child: Column(
        children: [
          _dataRow(
            Icons.people_alt_rounded,
            'Registered users',
            _count('users'),
          ),
          _dataRow(
            Icons.person_add_alt_1_rounded,
            'New user records',
            _count('users'),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Firebase Authentication users'),
            subtitle: Text(
              'Full Auth user count will be connected through Admin SDK.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionsSection() {
    return Card(
      child: Column(
        children: [
          _dataRow(
            Icons.receipt_long_rounded,
            'Total transaction records',
            _count('transactions'),
          ),
          const ListTile(
            leading: Icon(Icons.insights_rounded),
            title: Text('Transaction activity'),
            subtitle: Text(
              'Live data will appear when transaction records are stored in Firestore.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsSection() {
    return Card(
      child: Column(
        children: [
          _dataRow(
            Icons.event_rounded,
            'Analytics events',
            _count('analytics_events'),
          ),
          const ListTile(
            leading: Icon(Icons.analytics_rounded),
            title: Text('Firebase Analytics'),
            subtitle: Text(
              'Detailed Analytics reporting will be connected separately.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _downloadsSection() {
    return Card(
      child: const ListTile(
        leading: Icon(
          Icons.download_rounded,
          color: orange,
        ),
        title: Text('Report Downloads'),
        subtitle: Text(
          'Download tracking will be connected when the download system is implemented.',
        ),
      ),
    );
  }

  Widget _premiumSection() {
    return Card(
      child: Column(
        children: [
          _dataRow(
            Icons.workspace_premium_rounded,
            'Premium users',
            _count('premium_users'),
          ),
          const ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text('Plans'),
            subtitle: Text(
              'Monthly ₹99 • Yearly ₹1,099',
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationsSection() {
    return Card(
      child: Column(
        children: [
          _dataRow(
            Icons.notifications_active_rounded,
            'Notification records',
            _count('notifications'),
          ),
          const ListTile(
            leading: Icon(Icons.campaign_outlined),
            title: Text('Notifications'),
            subtitle: Text(
              'Notification sending system will be connected later.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsSection() {
    return Card(
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text('Application configuration'),
            subtitle: Text(
              'Remote application controls will be added here.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.cloud_done_outlined),
            title: Text('Firebase'),
            subtitle: Text(
              'Connected to CashTrack Firebase project.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _securitySection() {
    return Card(
      child: const Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.verified_user_rounded,
              color: green,
            ),
            title: Text('Admin authorization'),
            subtitle: Text(
              'Protected admin account: sabrojalam54321@gmail.com',
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline_rounded),
            title: Text('Firestore security'),
            subtitle: Text(
              'Admin data is restricted by Firestore rules.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataRow(
    IconData icon,
    String title,
    Stream<int> stream,
  ) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        final value = snapshot.hasData ? '${snapshot.data}' : '...';

        return ListTile(
          leading: CircleAvatar(
            child: Icon(icon),
          ),
          title: Text(title),
          trailing: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        );
      },
    );
  }
}
