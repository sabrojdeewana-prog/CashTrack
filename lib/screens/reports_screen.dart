import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../services/ads_service.dart';
import '../services/firebase_service.dart';
import '../services/pdf_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<CashTransaction> items = [];

  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    final data = await DatabaseHelper.instance.getAll();
    if (mounted) setState(() => items = data.where((e)=>e.type=='expense').toList());
  }

  Map<String,double> get totals {
    final m=<String,double>{};
    for(final e in items) { m[e.category]=(m[e.category]??0)+e.amount; }
    return m;
  }

  void export() {
    AdsService().showRewarded(onComplete: () async {
      await PdfService.createAndPrint(items);
      await FirebaseService.reportDownloaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t=totals;
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: items.isEmpty ? const Center(child: Text('No expense data yet.')) : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(height: 280, child: PieChart(PieChartData(
            sections: t.entries.map((e) => PieChartSectionData(value:e.value, title:e.key, radius:90, titleStyle: const TextStyle(fontSize:11))).toList(),
          ))),
          const SizedBox(height: 20),
          ...t.entries.map((e)=>ListTile(title:Text(e.key), trailing:Text('₹ ${e.value.toStringAsFixed(2)}'))),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: export, icon: const Icon(Icons.picture_as_pdf), label: const Text('Export PDF Report')),
        ],
      ),
    );
  }
}
