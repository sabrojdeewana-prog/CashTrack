import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import 'calculator_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color navy = Color(0xFF172033);
  static const Color blue = Color(0xFF1565C0);
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFDC2626);
  static const Color orange = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF5F7FB);

  List<CashTransaction> items = [];

  DateTime get now => DateTime.now();

  double get income =>
      items.where((e) => e.type == 'income').fold(0, (s, e) => s + e.amount);

  double get expense =>
      items.where((e) => e.type == 'expense').fold(0, (s, e) => s + e.amount);

  double get balance => income - expense;

  bool isThisMonth(CashTransaction e) =>
      e.date.year == now.year && e.date.month == now.month;

  bool isToday(CashTransaction e) =>
      e.date.year == now.year &&
      e.date.month == now.month &&
      e.date.day == now.day;

  double get monthlyIncome => items
      .where((e) => e.type == 'income' && isThisMonth(e))
      .fold(0, (s, e) => s + e.amount);

  double get monthlyExpense => items
      .where((e) => e.type == 'expense' && isThisMonth(e))
      .fold(0, (s, e) => s + e.amount);

  double get monthlyBalance => monthlyIncome - monthlyExpense;

  double get todayExpense => items
      .where((e) => e.type == 'expense' && isToday(e))
      .fold(0, (s, e) => s + e.amount);

  int get transactionCount => items.length;

  int get daysLeftInMonth {
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    return lastDay - now.day;
  }

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[now.month - 1];
  }

  String get topCategory {
    final Map<String, double> totals = {};

    for (final transaction in items.where(
      (e) => e.type == 'expense' && isThisMonth(e),
    )) {
      final category = transaction.category.trim().isEmpty
          ? 'Other'
          : transaction.category.trim();

      totals[category] = (totals[category] ?? 0) + transaction.amount;
    }

    if (totals.isEmpty) return 'No spending';

    final top = totals.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );

    return '${top.key} • ₹${top.value.toStringAsFixed(0)}';
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await DatabaseHelper.instance.getAll();

      if (!mounted) return;

      setState(() {
        items = data;
      });
    } catch (_) {}
  }

  Future<void> addTransaction() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionScreen(),
      ),
    );

    if (changed == true) {
      await load();
    }
  }

  String money(double value) => '₹${value.toStringAsFixed(0)}';

  String dateText(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String transactionSubtitle(CashTransaction transaction) {
    final person = transaction.personName.trim();
    final note = transaction.note.trim();

    if (person.isNotEmpty && note.isNotEmpty) {
      return '$person • $note';
    }

    if (person.isNotEmpty) return person;
    if (note.isNotEmpty) return note;

    return dateText(transaction.date);
  }

  @override
  Widget build(BuildContext context) {
    final recentItems = items.take(5).toList();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 18,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CashTrack',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w900,
                color: navy,
              ),
            ),
            Text(
              'Smart money management',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reports',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.bar_chart_rounded,
              color: navy,
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: navy,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: blue,
        onRefresh: load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            _balanceCard(),
            const SizedBox(height: 20),

            _sectionHeader(
              'Monthly Snapshot',
              monthName,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    Icons.south_west_rounded,
                    'Income',
                    money(monthlyIncome),
                    'This month',
                    green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    Icons.north_east_rounded,
                    'Expenses',
                    money(monthlyExpense),
                    'This month',
                    red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    Icons.today_rounded,
                    'Today',
                    money(todayExpense),
                    'Spent today',
                    orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    Icons.calendar_month_rounded,
                    'Month Left',
                    '$daysLeftInMonth days',
                    'Remaining',
                    blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _insightCard(),

            const SizedBox(height: 25),

            _sectionHeader(
              'Quick Actions',
              'Manage your money',
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    Icons.add_circle_outline_rounded,
                    'Add Income',
                    green,
                    addTransaction,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    Icons.remove_circle_outline_rounded,
                    'Add Expense',
                    red,
                    addTransaction,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _fullAction(
              Icons.calculate_rounded,
              'Smart Calculator',
              blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalculatorScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _sectionHeader(
                    'Recent Transactions',
                    recentItems.isEmpty
                        ? 'No recent activity'
                        : 'Latest activity',
                  ),
                ),
                if (items.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: blue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            if (recentItems.isEmpty)
              _emptyState()
            else
              ...recentItems.map(_transactionTile),

            const SizedBox(height: 18),

            if (items.isNotEmpty) _monthlyOverview(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addTransaction,
        backgroundColor: blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _balanceCard() {
    final positive = balance >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0B5D3B),
            Color(0xFF12804F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B5D3B).withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Available Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  positive ? 'Healthy' : 'Review',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            money(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            positive
                ? 'Total income minus total expenses'
                : 'Expenses are higher than recorded income',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _balanceMini(
                  Icons.arrow_downward_rounded,
                  'Income',
                  money(income),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _balanceMini(
                  Icons.arrow_upward_rounded,
                  'Expense',
                  money(expense),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _balanceMini(
                  Icons.receipt_long_rounded,
                  'Entries',
                  '$transactionCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceMini(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.85),
            size: 17,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.70),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 122),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE8ECF3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 11),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCard() {
    final insight = monthlyExpense <= 0
        ? 'No expenses recorded this month. Keep tracking your spending.'
        : monthlyIncome <= 0
            ? 'You have expenses but no income recorded this month.'
            : monthlyExpense / monthlyIncome >= 0.9
                ? 'Most of your monthly income has been spent. Review your expenses.'
                : monthlyExpense / monthlyIncome >= 0.7
                    ? 'Your spending is relatively high compared with your income.'
                    : monthlyExpense / monthlyIncome >= 0.4
                        ? 'Your spending is moderate. Watch your larger categories.'
                        : 'Your spending is currently below 40% of income.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD8E9FF),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: blue.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: blue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spending Insight',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  insight,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Top category: $topCategory',
                  style: const TextStyle(
                    color: blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 92,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8ECF3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionIcon(icon, color),
              const SizedBox(height: 9),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullAction(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8ECF3),
            ),
          ),
          child: Row(
            children: [
              _actionIcon(icon, color),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 21,
      ),
    );
  }

  Widget _transactionTile(
    CashTransaction transaction,
  ) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? green : red;

    return Dismissible(
      key: ValueKey(
        '${transaction.id}_${transaction.date.millisecondsSinceEpoch}',
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (transaction.id == null) return false;

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text(
                'Delete transaction?',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: const Text(
                'This transaction will be permanently removed.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: red,
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );

        if (confirmed == true) {
          await DatabaseHelper.instance.delete(transaction.id!);
          await load();
          return true;
        }

        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(17),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFE8ECF3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                isIncome
                    ? Icons.south_west_rounded
                    : Icons.north_east_rounded,
                color: color,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category.isEmpty
                        ? 'Other'
                        : transaction.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    transactionSubtitle(transaction),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${isIncome ? '+' : '-'}${money(transaction.amount)}',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthlyOverview() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE8ECF3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Overview',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$monthName ${now.year}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 16),
          _overviewValue(
            'Income',
            money(monthlyIncome),
            green,
          ),
          const SizedBox(height: 11),
          _overviewValue(
            'Expenses',
            money(monthlyExpense),
            red,
          ),
          const SizedBox(height: 11),
          _overviewValue(
            'Balance',
            money(monthlyBalance),
            blue,
          ),
        ],
      ),
    );
  }

  Widget _overviewValue(
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE8ECF3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: blue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: blue,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No transactions yet',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Start tracking your income and expenses.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: addTransaction,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Add First Transaction',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
