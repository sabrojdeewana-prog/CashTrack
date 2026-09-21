import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../services/csv_service.dart';
import '../services/firebase_service.dart';
import '../services/pdf_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<CashTransaction> allItems = [];
  String period = 'Monthly';
  String typeFilter = 'All';
  String categoryFilter = 'All';
  DateTime selectedDate = DateTime.now();
  DateTime? customStart;
  DateTime? customEnd;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final data = await DatabaseHelper.instance.getAll();

    final categories = {
      'All',
      ...data.map((e) => e.category.trim()).where((e) => e.isNotEmpty),
    };

    if (!categories.contains(categoryFilter)) {
      categoryFilter = 'All';
    }

    if (mounted) {
      setState(() {
        allItems = data;
      });
    }
  }

  List<CashTransaction> get filteredItems {
    DateTime start;
    DateTime end;

    final day = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (period == 'Daily') {
      start = day;
      end = day.add(const Duration(days: 1));
    } else if (period == 'Weekly') {
      start = day.subtract(Duration(days: day.weekday - 1));
      end = start.add(const Duration(days: 7));
    } else if (period == 'Monthly') {
      start = DateTime(day.year, day.month);
      end = DateTime(day.year, day.month + 1);
    } else {
      if (customStart == null || customEnd == null) return [];
      start = DateTime(
        customStart!.year,
        customStart!.month,
        customStart!.day,
      );
      end = DateTime(
        customEnd!.year,
        customEnd!.month,
        customEnd!.day,
      ).add(const Duration(days: 1));
    }

    return allItems.where((e) {
      final date = e.date;
      final dateMatch =
          !date.isBefore(start) && date.isBefore(end);

      final typeMatch =
          typeFilter == 'All' || e.type == typeFilter.toLowerCase();

      final categoryMatch =
          categoryFilter == 'All' || e.category == categoryFilter;

      return dateMatch && typeMatch && categoryMatch;
    }).toList();
  }

  double get totalIncome => filteredItems
      .where((e) => e.type == 'income')
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => filteredItems
      .where((e) => e.type == 'expense')
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expenseByCategory {
    final result = <String, double>{};

    for (final item in filteredItems.where((e) => e.type == 'expense')) {
      result[item.category] =
          (result[item.category] ?? 0) + item.amount;
    }

    return result;
  }

  List<String> get categories {
    final values = allItems
        .map((e) => e.category.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return ['All', ...values];
  }

  String get periodText {
    if (period == 'Daily') {
      return DateFormat('dd MMM yyyy').format(selectedDate);
    }

    if (period == 'Weekly') {
      final start = selectedDate.subtract(
        Duration(days: selectedDate.weekday - 1),
      );
      final end = start.add(const Duration(days: 6));

      return '${DateFormat('dd MMM').format(start)} - '
          '${DateFormat('dd MMM yyyy').format(end)}';
    }

    if (period == 'Monthly') {
      return DateFormat('MMMM yyyy').format(selectedDate);
    }

    if (customStart != null && customEnd != null) {
      return '${DateFormat('dd MMM yyyy').format(customStart!)} - '
          '${DateFormat('dd MMM yyyy').format(customEnd!)}';
    }

    return 'Select date range';
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: customStart != null && customEnd != null
          ? DateTimeRange(start: customStart!, end: customEnd!)
          : null,
    );

    if (picked != null) {
      setState(() {
        customStart = picked.start;
        customEnd = picked.end;
      });
    }
  }

  Future<void> exportPdf() async {
    if (filteredItems.isEmpty) {
      _message('No transactions available for this report.');
      return;
    }

    await PdfService.createAndPrint(
      filteredItems,
      title: 'CashTrack $period Report',
    );

    await FirebaseService.reportDownloaded();
  }

  Future<void> exportCsv() async {
    if (filteredItems.isEmpty) {
      _message('No transactions available for this report.');
      return;
    }

    await CsvService.export(filteredItems);
    _message('CSV report exported successfully.');
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Widget filterDropdown({
    required String value,
    required List<String> values,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: values.contains(value) ? value : values.first,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      items: values
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }

  Widget summaryCard(
    String title,
    double value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  '₹${value.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = expenseByCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            filterDropdown(
              value: period,
              values: const [
                'Daily',
                'Weekly',
                'Monthly',
                'Custom',
              ],
              label: 'Period',
              onChanged: (value) {
                setState(() {
                  period = value;
                });
              },
            ),
            const SizedBox(height: 12),

            filterDropdown(
              value: typeFilter,
              values: const [
                'All',
                'Income',
                'Expense',
              ],
              label: 'Transaction Type',
              onChanged: (value) {
                setState(() {
                  typeFilter = value;
                });
              },
            ),
            const SizedBox(height: 12),

            filterDropdown(
              value: categoryFilter,
              values: categories,
              label: 'Category',
              onChanged: (value) {
                setState(() {
                  categoryFilter = value;
                });
              },
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: period == 'Custom'
                  ? pickCustomRange
                  : pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(periodText),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                summaryCard(
                  'Income',
                  totalIncome,
                  Icons.arrow_downward,
                  Colors.green,
                ),
                summaryCard(
                  'Expense',
                  totalExpense,
                  Icons.arrow_upward,
                  Colors.red,
                ),
                summaryCard(
                  'Balance',
                  balance,
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (filteredItems.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(
                    child: Text(
                      'No transactions found for selected filters.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    18,
                    12,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Income vs Expense',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 230,
                        child: BarChart(
                          BarChartData(
                            maxY: [
                              totalIncome,
                              totalExpense,
                              1,
                            ].reduce((a, b) => a > b ? a : b) * 1.2,
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalIncome,
                                    width: 45,
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: totalExpense,
                                    width: 45,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final text =
                                        value == 0 ? 'Income' : 'Expense';

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(top: 8),
                                      child: Text(text),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (expenses.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expense by Category',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections: expenses.entries.map((entry) {
                                return PieChartSectionData(
                                  value: entry.value,
                                  title: entry.key,
                                  radius: 90,
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              Card(
                child: Column(
                  children: filteredItems.map((item) {
                    final isIncome = item.type == 'income';

                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          isIncome
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(item.category),
                      subtitle: Text(
                        '${DateFormat('dd MMM yyyy').format(item.date)}'
                        '${item.note.isNotEmpty ? ' • ${item.note}' : ''}',
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}₹${item.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: exportPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: exportCsv,
                    icon: const Icon(Icons.table_chart),
                    label: const Text('CSV'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
