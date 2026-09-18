import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../services/ads_service.dart';
import 'add_transaction_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CashTransaction> items = [];
  BannerAd? banner;

  double get income => items.where((e)=>e.type=='income').fold(0,(s,e)=>s+e.amount);
  double get expense => items.where((e)=>e.type=='expense').fold(0,(s,e)=>s+e.amount);

  @override
  void initState() {
    super.initState();
    load();
    banner = AdsService().createBanner(onLoaded: () => setState(() {}));
  }

  Future<void> load() async {
    final data = await DatabaseHelper.instance.getAll();
    if (mounted) setState(() => items = data);
  }

  @override
  void dispose() {
    banner?.dispose();
    super.dispose();
  }

  Future<void> add() async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
    if (changed == true) load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CashTrack'),
        actions: [
          IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen()))),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Available Balance', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text('₹ ${(income-expense).toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Income\n₹ ${income.toStringAsFixed(2)}'),
                    Text('Expenses\n₹ ${expense.toStringAsFixed(2)}'),
                  ]),
                ]),
              ),
            ),
          ),
          Expanded(
            child: items.isEmpty
              ? const Center(child: Text('No transactions yet.\nTap + to add one.', textAlign: TextAlign.center))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final e = items[i];
                    return Dismissible(
                      key: ValueKey(e.id),
                      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete)),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) async { await DatabaseHelper.instance.delete(e.id!); load(); },
                      child: ListTile(
                        leading: CircleAvatar(child: Icon(e.type=='income' ? Icons.arrow_upward : Icons.arrow_downward)),
                        title: Text(e.category),
                        subtitle: Text(e.note.isEmpty ? e.date.toLocal().toString().split('.').first : e.note),
                        trailing: Text('${e.type=="income" ? "+" : "-"}₹${e.amount.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
          ),
          if (banner != null) SizedBox(width: banner!.size.width.toDouble(), height: banner!.size.height.toDouble(), child: AdWidget(ad: banner!)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: add, child: const Icon(Icons.add)),
    );
  }
}
