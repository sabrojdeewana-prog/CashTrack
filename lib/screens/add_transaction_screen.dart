import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amount = TextEditingController();
  final note = TextEditingController();

  String type = 'expense';
  String category = 'Food';

  final List<String> categories = [
    'Food',
    'Groceries',
    'Restaurant',
    'Tea & Coffee',
    'Bills',
    'Electricity',
    'Water',
    'Gas',
    'Mobile Recharge',
    'Internet',
    'Rent',
    'Home',
    'Home Repair',
    'Shopping',
    'Clothes',
    'Shoes',
    'Entertainment',
    'Movies',
    'Games',
    'Travel',
    'Petrol & Diesel',
    'Taxi & Auto',
    'Bus & Metro',
    'Train',
    'Flight',
    'Parking',
    'Vehicle Service',
    'Education',
    'Books',
    'Courses',
    'Office',
    'Business',
    'Software & Apps',
    'Medical',
    'Medicine',
    'Health',
    'Gym & Fitness',
    'Personal Care',
    'Beauty',
    'Gifts',
    'Family',
    'Kids',
    'Insurance',
    'Bank Charges',
    'ATM & Cash',
    'Loan Payment',
    'EMI',
    'Credit Card',
    'Investment',
    'Savings',
    'Money Sent',
    'Money Received',
    'Lent Money',
    'Borrowed Money',
    'Loan Given',
    'Loan Received',
    'Loan Repaid',
    'Debt Repaid',
    'Donation',
    'Charity',
    'Subscriptions',
    'Shopping Online',
    'Delivery',
    'Work',
    'Other',
  ];

  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final value = double.tryParse(amount.text.trim());

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid amount'),
        ),
      );
      return;
    }

    await DatabaseHelper.instance.insert(
      CashTransaction(
        type: type,
        amount: value,
        category: category,
        note: note.text.trim(),
        date: DateTime.now(),
      ),
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> selectCategory() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CategoryPicker(
          categories: categories,
          selectedCategory: category,
        );
      },
    );

    if (selected != null) {
      setState(() {
        category = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF5F7FB),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'expense',
                label: Text('Expense'),
                icon: Icon(Icons.arrow_downward_rounded),
              ),
              ButtonSegment(
                value: 'income',
                label: Text('Income'),
                icon: Icon(Icons.arrow_upward_rounded),
              ),
            ],
            selected: {type},
            onSelectionChanged: (s) {
              setState(() => type = s.first);
            },
          ),

          const SizedBox(height: 20),

          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),

          const SizedBox(height: 15),

          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: selectCategory,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.category_outlined),
                suffixIcon: Icon(Icons.search_rounded),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: note,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              hintText: 'Add a note about this transaction',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.notes_rounded),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Save Transaction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPicker extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;

  const _CategoryPicker({
    required this.categories,
    required this.selectedCategory,
  });

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  final searchController = TextEditingController();

  List<String> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.categories;
    searchController.addListener(filterCategories);
  }

  void filterCategories() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      filteredCategories = query.isEmpty
          ? widget.categories
          : widget.categories
              .where(
                (c) => c.toLowerCase().contains(query),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(filterCategories);
    searchController.dispose();
    super.dispose();
  }

  IconData categoryIcon(String name) {
    final value = name.toLowerCase();

    if (value.contains('food') ||
        value.contains('restaurant') ||
        value.contains('tea') ||
        value.contains('grocer')) {
      return Icons.restaurant_rounded;
    }

    if (value.contains('bill') ||
        value.contains('electric') ||
        value.contains('water') ||
        value.contains('gas') ||
        value.contains('internet') ||
        value.contains('mobile')) {
      return Icons.receipt_long_rounded;
    }

    if (value.contains('rent') ||
        value.contains('home')) {
      return Icons.home_rounded;
    }

    if (value.contains('shopping') ||
        value.contains('clothes') ||
        value.contains('shoes')) {
      return Icons.shopping_bag_rounded;
    }

    if (value.contains('travel') ||
        value.contains('taxi') ||
        value.contains('bus') ||
        value.contains('metro') ||
        value.contains('train') ||
        value.contains('flight') ||
        value.contains('parking') ||
        value.contains('petrol') ||
        value.contains('vehicle')) {
      return Icons.directions_car_rounded;
    }

    if (value.contains('entertainment') ||
        value.contains('movie') ||
        value.contains('game')) {
      return Icons.movie_rounded;
    }

    if (value.contains('education') ||
        value.contains('book') ||
        value.contains('course')) {
      return Icons.school_rounded;
    }

    if (value.contains('medical') ||
        value.contains('medicine') ||
        value.contains('health')) {
      return Icons.medical_services_rounded;
    }

    if (value.contains('loan') ||
        value.contains('debt') ||
        value.contains('borrow') ||
        value.contains('lent') ||
        value.contains('money')) {
      return Icons.swap_horiz_rounded;
    }

    if (value.contains('saving') ||
        value.contains('investment')) {
      return Icons.savings_rounded;
    }

    if (value.contains('gift') ||
        value.contains('family') ||
        value.contains('kids')) {
      return Icons.family_restroom_rounded;
    }

    if (value.contains('insurance') ||
        value.contains('bank') ||
        value.contains('atm') ||
        value.contains('credit') ||
        value.contains('emi')) {
      return Icons.account_balance_rounded;
    }

    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FB),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Select Category',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search category...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                    child: Text(
                      'No category found',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final item = filteredCategories[index];
                      final selected =
                          item == widget.selectedCategory;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context, item);
                          },
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              categoryIcon(item),
                              color: const Color(0xFF1565C0),
                              size: 21,
                            ),
                          ),
                          title: Text(
                            item,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          trailing: selected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF1565C0),
                                )
                              : const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey,
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
