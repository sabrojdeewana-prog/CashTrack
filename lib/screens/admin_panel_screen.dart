import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

@override  void initState() {    super.initState();    _loadAnalytics();  }  Future<void> _loadAnalytics() async {    try {      final client = HttpClient();      final apiPeriod = period == 'Today' ? 'today' : period == '7 Days' ? '7days' : period == '30 Days' ? '30days' : 'lifetime';      final uri = Uri.parse('$analyticsUrl?period=$apiPeriod');      final request = await client.getUrl(uri);      final response = await request.close();      final body = await utf8.decoder.bind(response).join();      client.close();      if (response.statusCode != 200) throw Exception('HTTP ${response.statusCode}');      final data = jsonDecode(body) as Map<String, dynamic>;      setState(() {        analytics = data;        loadingAnalytics = false;        analyticsError = null;      });    } catch (e) {      setState(() {        loadingAnalytics = false;        analyticsError = e.toString();      });    }  }
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  static const Color navy = Color(0xFF172033);
  static const Color blue = Color(0xFF1565C0);
  static const Color green = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFDC2626);
  static const Color purple = Color(0xFF7C3AED);
  static const Color background = Color(0xFFF5F7FB);

  String period = 'Lifetime';
Map<String, dynamic>? analytics;  bool loadingAnalytics = true;  String? analyticsError;  static const String analyticsUrl = 'https://script.google.com/macros/s/AKfycbwF8aLg9NWk20F9m7K0szXmAoXl4ehhXxE0GWcacHNwQDVojPCQadjZxHXPD-T4jGQHvQ/exec';

@override  void initState() {    super.initState();    _loadAnalytics();  }  Future<void> _loadAnalytics() async {    try {      final client = HttpClient();      final apiPeriod = period == 'Today' ? 'today' : period == '7 Days' ? '7days' : period == '30 Days' ? '30days' : 'lifetime';      final uri = Uri.parse('$analyticsUrl?period=$apiPeriod');      final request = await client.getUrl(uri);      final response = await request.close();      final body = await utf8.decoder.bind(response).join();      client.close();      if (response.statusCode != 200) throw Exception('HTTP ${response.statusCode}');      final data = jsonDecode(body) as Map<String, dynamic>;      setState(() {        analytics = data;        loadingAnalytics = false;        analyticsError = null;      });    } catch (e) {      setState(() {        loadingAnalytics = false;        analyticsError = e.toString();      });    }  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: Text(
          'CashTrack Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _hero(),
            const SizedBox(height: 16),

            _periodFilter(),
            const SizedBox(height: 18),

            _sectionTitle(
              Icons.dashboard_rounded,
              'Dashboard Overview',
            ),
            const SizedBox(height: 10),
            _overviewGrid(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.people_alt_rounded,
              'Users & Activity',
            ),
            const SizedBox(height: 10),
            _usersCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.analytics_rounded,
              'Real Analytics',
            ),
            const SizedBox(height: 10),
            _analyticsCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.calculate_rounded,
              'Calculator Usage',
            ),
            const SizedBox(height: 10),
            _calculatorCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.receipt_long_rounded,
              'Transactions & Reports',
            ),
            const SizedBox(height: 10),
            _activityCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.store_rounded,
              'Store & Download Statistics',
            ),
            const SizedBox(height: 10),
            _storeCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.workspace_premium_rounded,
              'Premium',
            ),
            const SizedBox(height: 10),
            _premiumCard(),

            const SizedBox(height: 24),
            _sectionTitle(
              Icons.security_rounded,
              'Admin & Security',
            ),
            const SizedBox(height: 10),
            _securityCard(),

            const SizedBox(height: 28),

            const Center(
              child: Text(
                'CashTrack Admin • Real-data dashboard',
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

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [navy, blue],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: navy,
              size: 34,
            ),
          ),
          SizedBox(width: 14),
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
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 9,
                      color: Colors.greenAccent,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Admin session active',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodFilter() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.date_range_rounded, color: blue),
            const SizedBox(width: 10),
            Text(
              'Period',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: period,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: 'Today',
                  child: Text('Today'),
                ),
                DropdownMenuItem(
                  value: '7 Days',
                  child: Text('7 Days'),
                ),
                DropdownMenuItem(
                  value: '30 Days',
                  child: Text('30 Days'),
                ),
                DropdownMenuItem(
                  value: 'Lifetime',
                  child: Text('Lifetime'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => period = value); _loadAnalytics();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.45,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _metricCard(
          loadingAnalytics ? 'Loading...' : '${analytics?['activeUsers'] ?? 0}',
          'Active Users',
          'Analytics',
          Icons.people_alt_rounded,
          blue,
        ),
        _metricCard(
          loadingAnalytics ? 'Loading...' : '${analytics?['appOpens'] ?? 0}',
          'App Opens',
          'Analytics',
          Icons.login_rounded,
          green,
        ),
        _metricCard(
          loadingAnalytics ? 'Loading...' : '${analytics?['firstOpens'] ?? 0}',
          'First Opens',
          'Analytics',
          Icons.rocket_launch_rounded,
          purple,
        ),
        _metricCard(
          loadingAnalytics ? 'Loading...' : '${analytics?['eventCount'] ?? 0}',
          'Events',
          'Analytics',
          Icons.insights_rounded,
          orange,
        ),
      ],
    );
  }

  Widget _metricCard(
    String value,
    String title,
    String source,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 27),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              source,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usersCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.people_alt_rounded,
            'Active users',
            'Firebase Analytics data source',
            blue,
          ),
          _infoTile(
            Icons.person_add_alt_1_rounded,
            'New users / first opens',
            'Firebase Analytics data source',
            green,
          ),
          _infoTile(
            Icons.access_time_rounded,
            'Recent activity',
            'Analytics event timeline',
            purple,
          ),
        ],
      ),
    );
  }

  Widget _analyticsCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.cloud_done_rounded,
            'Firebase Analytics',
            'Connected',
            green,
          ),
          _infoTile(
            Icons.storage_rounded,
            'BigQuery export',
            'Daily export configured',
            blue,
          ),
          _infoTile(
            Icons.sync_rounded,
            'Data availability',
            'Initial export may take time',
            orange,
          ),
          _infoTile(
            Icons.lock_rounded,
            'Analytics access',
            'Secure backend connection required for in-app raw data',
            red,
          ),
        ],
      ),
    );
  }

  Widget _calculatorCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.calculate_rounded,
            'Calculator usage',
            loadingAnalytics ? 'Loading...' : 'Uses: ${analytics?['calculatorUses'] ?? 0}',
            blue,
          ),
          _infoTile(
            Icons.bar_chart_rounded,
            'Most used tool',
            'Real Analytics data',
            green,
          ),
          _infoTile(
            Icons.history_rounded,
            'Usage history',
            'Daily / 7 Days / 30 Days / Lifetime',
            purple,
          ),
        ],
      ),
    );
  }

  Widget _activityCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.receipt_long_rounded,
            'Transactions',
            loadingAnalytics ? 'Loading...' : 'Added: ${analytics?['transactions'] ?? 0}',
            green,
          ),
          _infoTile(
            Icons.picture_as_pdf_rounded,
            'PDF reports',
            loadingAnalytics ? 'Loading...' : 'Downloaded: ${analytics?['reports'] ?? 0}',
            orange,
          ),
          _infoTile(
            Icons.timeline_rounded,
            'Activity timeline',
            'Real Analytics event data',
            blue,
          ),
        ],
      ),
    );
  }

  Widget _storeCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _storeRow(
            Icons.play_arrow_rounded,
            'Google Play',
          ),
          _storeRow(
            Icons.shopping_bag_rounded,
            'Amazon Appstore',
          ),
          _storeRow(
            Icons.storefront_rounded,
            'Samsung Galaxy Store',
          ),
          _storeRow(
            Icons.download_rounded,
            'Direct APK',
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: orange,
            ),
            title: Text(
              'Download statistics',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Store download numbers require official store reporting data. They will not be replaced with fake Firebase numbers.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeRow(IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: blue.withValues(alpha: 0.10),
        child: Icon(icon, color: blue),
      ),
      title: Text(title),
      trailing: Text(
        'Active Users',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _premiumCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.workspace_premium_rounded,
            'Premium users',
            'Real purchase/subscription data required',
            orange,
          ),
          _infoTile(
            Icons.calendar_month_rounded,
            'Monthly plan',
            '₹99',
            blue,
          ),
          _infoTile(
            Icons.star_rounded,
            'Yearly plan',
            '₹1,099',
            purple,
          ),
          const ListTile(
            leading: Icon(
              Icons.verified_outlined,
              color: red,
            ),
            title: Text('Verification'),
            subtitle: Text(
              'Premium count will only be shown after real billing verification is connected.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _securityCard() {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          _infoTile(
            Icons.verified_user_rounded,
            'Admin authorization',
            'Protected admin account',
            green,
          ),
          _infoTile(
            Icons.email_rounded,
            'Admin account',
            'sabrojalam54321@gmail.com',
            blue,
          ),
          _infoTile(
            Icons.security_rounded,
            'Dashboard security',
            'Admin-only screen',
            purple,
          ),
          _infoTile(
            Icons.warning_amber_rounded,
            'Server-side security',
            'Backend authorization still required',
            orange,
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.10),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
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
}
