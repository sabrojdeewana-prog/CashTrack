import 'dart:math' as math;
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<String> tools = [
    'Basic',
    'Percentage',
    'GST',
    'EMI',
    'Simple Interest',
    'Compound Interest',
    'Profit & Loss',
    'Discount',
    'Bill Splitter',
    'Savings',
    'Loan Schedule',
    'Tax',
    'History',
  ];

  int selected = 0;
  final List<String> history = [];

  final amount = TextEditingController();
  final second = TextEditingController();
  final rate = TextEditingController();
  final time = TextEditingController();
  final people = TextEditingController();

  String result = '';

  double number(TextEditingController c) {
    return double.tryParse(c.text.trim()) ?? 0;
  }

  void clearFields() {
    amount.clear();
    second.clear();
    rate.clear();
    time.clear();
    people.clear();
    setState(() => result = '');
  }

  void saveHistory(String text) {
    history.insert(0, text);
    if (history.length > 50) {
      history.removeLast();
    }
  }

  void calculate() {
    final a = number(amount);
    final b = number(second);
    final r = number(rate);
    final t = number(time);

    double value = 0;
    String text = '';

    switch (selected) {
      case 1:
        value = a * b / 100;
        text = '₹${a.toStringAsFixed(2)} × $b% = ₹${value.toStringAsFixed(2)}';
        break;

      case 2:
        value = a * b / 100;
        final total = a + value;
        text =
            'GST ₹${value.toStringAsFixed(2)} • Total ₹${total.toStringAsFixed(2)}';
        break;

      case 3:
        if (r == 0 || t == 0) {
          text = 'Enter loan, interest and tenure';
        } else {
          final monthlyRate = r / 12 / 100;
          final months = t * 12;
          final emi = a *
              monthlyRate *
              math.pow(1 + monthlyRate, months) /
              (math.pow(1 + monthlyRate, months) - 1);
          text = 'Monthly EMI: ₹${emi.toStringAsFixed(2)}';
        }
        break;

      case 4:
        final interest = a * r * t / 100;
        text =
            'Interest: ₹${interest.toStringAsFixed(2)} • Total: ₹${(a + interest).toStringAsFixed(2)}';
        break;

      case 5:
        final total = a * math.pow(1 + r / 100, t);
        final interest = total - a;
        text =
            'Interest: ₹${interest.toStringAsFixed(2)} • Total: ₹${total.toStringAsFixed(2)}';
        break;

      case 6:
        final profit = b - a;
        final percent = a == 0 ? 0 : profit / a * 100;
        text =
            '${profit >= 0 ? "Profit" : "Loss"}: ₹${profit.abs().toStringAsFixed(2)} • ${percent.abs().toStringAsFixed(2)}%';
        break;

      case 7:
        final discount = a * b / 100;
        final finalPrice = a - discount;
        text =
            'Discount: ₹${discount.toStringAsFixed(2)} • Pay: ₹${finalPrice.toStringAsFixed(2)}';
        break;

      case 8:
        final count = number(people);
        if (count <= 0) {
          text = 'Enter number of people';
        } else {
          final each = a / count;
          text = 'Each person pays: ₹${each.toStringAsFixed(2)}';
        }
        break;

      case 9:
        final saved = a * b / 100;
        text =
            'Monthly saving: ₹${saved.toStringAsFixed(2)} • After saving: ₹${(a - saved).toStringAsFixed(2)}';
        break;

      case 11:
        final tax = a * b / 100;
        text =
            'Tax: ₹${tax.toStringAsFixed(2)} • Total: ₹${(a + tax).toStringAsFixed(2)}';
        break;

      default:
        return;
    }

    setState(() => result = text);
    if (text.isNotEmpty) saveHistory(text);
  }

  Widget input(
    String label,
    TextEditingController controller, {
    String hint = '0',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget calculatorCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required int index,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.10),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          setState(() {
            selected = index; amount.clear(); second.clear(); rate.clear(); time.clear(); people.clear();
            result = '';
            clearFields();
          });
        },
      ),
    );
  }

  Widget toolForm() {
    switch (selected) {
      case 0:
        return _basicCalculator();

      case 1:
        return _form(
          title: 'Percentage',
          inputs: [
            input('Amount', amount),
            input('Percentage', second),
          ],
        );

      case 2:
        return _form(
          title: 'GST Calculator',
          inputs: [
            input('Amount', amount),
            input('GST %', second, hint: '18'),
          ],
        );

      case 3:
        return _form(
          title: 'EMI Calculator',
          inputs: [
            input('Loan Amount', amount),
            input('Annual Interest %', rate),
            input('Loan Tenure (Years)', time),
          ],
        );

      case 4:
        return _form(
          title: 'Simple Interest',
          inputs: [
            input('Principal', amount),
            input('Interest Rate %', rate),
            input('Time (Years)', time),
          ],
        );

      case 5:
        return _form(
          title: 'Compound Interest',
          inputs: [
            input('Principal', amount),
            input('Interest Rate %', rate),
            input('Time (Years)', time),
          ],
        );

      case 6:
        return _form(
          title: 'Profit & Loss',
          inputs: [
            input('Cost Price', amount),
            input('Selling Price', second),
          ],
        );

      case 7:
        return _form(
          title: 'Discount',
          inputs: [
            input('Original Price', amount),
            input('Discount %', second),
          ],
        );

      case 8:
        return _form(
          title: 'Bill Splitter',
          inputs: [
            input('Total Bill', amount),
            input('Number of People', people),
          ],
        );

      case 9:
        return _form(
          title: 'Savings Calculator',
          inputs: [
            input('Monthly Income', amount),
            input('Saving %', second),
          ],
        );

      case 10:
        return _loanSchedule();

      case 11:
        return _form(
          title: 'Tax Calculator',
          inputs: [
            input('Amount', amount),
            input('Tax %', second),
          ],
        );

      case 12:
        return _history();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _form({
    required String title,
    required List<Widget> inputs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        ...inputs,
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: calculate,
            child: const Text(
              'Calculate',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (result.isNotEmpty) ...[
          const SizedBox(height: 16),
          _resultCard(),
        ],
      ],
    );
  }

  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        result,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _basicCalculator() {
    return _BasicCalculator(
      onHistory: (text) {
        setState(() => saveHistory(text));
      },
    );
  }

  Widget _loanSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loan / EMI Schedule',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        input('Loan Amount', amount),
        input('Annual Interest %', rate),
        input('Tenure (Years)', time),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              final principal = number(amount);
              final annualRate = number(rate);
              final years = number(time);

              if (principal <= 0 || annualRate <= 0 || years <= 0) {
                setState(() => result = 'Enter valid loan details');
                return;
              }

              final monthlyRate = annualRate / 12 / 100;
              final months = (years * 12).round();
              final factor = math.pow(1 + monthlyRate, months);
              final emi =
                  principal * monthlyRate * factor / (factor - 1);

              setState(() {
                result =
                    'EMI: ₹${emi.toStringAsFixed(2)} • ${months} months';
              });
              saveHistory(result);
            },
            child: const Text(
              'Generate Schedule',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (result.isNotEmpty) ...[
          const SizedBox(height: 16),
          _resultCard(),
        ],
      ],
    );
  }

  Widget _history() {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            'No calculations yet',
            style: TextStyle(fontSize: 17),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calculation History',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            TextButton(
              onPressed: () => setState(history.clear),
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...history.map(
          (item) => Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.history_rounded),
              title: Text(item),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    amount.dispose();
    second.dispose();
    rate.dispose();
    time.dispose();
    people.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTitle = tools[selected];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
        title: const Text(
          'Smart Calculator',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          if (selected == 0) ...[
            const Text(
              'All Calculator Tools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            calculatorCard(
              title: 'Basic Calculator',
              subtitle: 'Everyday calculations',
              icon: Icons.calculate_rounded,
              index: 0,
            ),
            calculatorCard(
              title: 'Percentage',
              subtitle: 'Find percentage and amount',
              icon: Icons.percent_rounded,
              index: 1,
            ),
            calculatorCard(
              title: 'GST Calculator',
              subtitle: 'Calculate GST and total',
              icon: Icons.receipt_long_rounded,
              index: 2,
            ),
            calculatorCard(
              title: 'EMI Calculator',
              subtitle: 'Calculate monthly loan EMI',
              icon: Icons.account_balance_rounded,
              index: 3,
            ),
            calculatorCard(
              title: 'Simple Interest',
              subtitle: 'Calculate simple interest',
              icon: Icons.savings_rounded,
              index: 4,
            ),
            calculatorCard(
              title: 'Compound Interest',
              subtitle: 'Calculate compound growth',
              icon: Icons.trending_up_rounded,
              index: 5,
            ),
            calculatorCard(
              title: 'Profit & Loss',
              subtitle: 'Check profit or loss',
              icon: Icons.show_chart_rounded,
              index: 6,
            ),
            calculatorCard(
              title: 'Discount',
              subtitle: 'Calculate discounted price',
              icon: Icons.local_offer_rounded,
              index: 7,
            ),
            calculatorCard(
              title: 'Bill Splitter',
              subtitle: 'Split bills between people',
              icon: Icons.people_alt_rounded,
              index: 8,
            ),
            calculatorCard(
              title: 'Savings',
              subtitle: 'Plan your monthly savings',
              icon: Icons.wallet_rounded,
              index: 9,
            ),
            calculatorCard(
              title: 'Loan Schedule',
              subtitle: 'Calculate EMI schedule',
              icon: Icons.calendar_month_rounded,
              index: 10,
            ),
            calculatorCard(
              title: 'Tax / GST',
              subtitle: 'Calculate tax amount',
              icon: Icons.account_balance_wallet_rounded,
              index: 11,
            ),
            calculatorCard(
              title: 'Calculation History',
              subtitle: 'View previous calculations',
              icon: Icons.history_rounded,
              index: 12,
            ),
          ] else ...[
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    selected = 0;
                    clearFields();
                  }),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Text(
                    selectedTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            toolForm(),
          ],
        ],
      ),
    );
  }
}

class _BasicCalculator extends StatefulWidget {
  final void Function(String) onHistory;

  const _BasicCalculator({required this.onHistory});

  @override
  State<_BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<_BasicCalculator> {
  String display = '0';
  double? first;
  String? operation;
  bool reset = false;

  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        first = null;
        operation = null;
        reset = false;
        return;
      }

      if (value == '⌫') {
        display = display.length > 1
            ? display.substring(0, display.length - 1)
            : '0';
        return;
      }

      if (['+', '−', '×', '÷'].contains(value)) {
        first = double.tryParse(display);
        operation = value;
        reset = true;
        return;
      }

      if (value == '=') {
        final second = double.tryParse(display);
        if (first == null || second == null || operation == null) return;

        double answer;

        switch (operation) {
          case '+':
            answer = first! + second;
            break;
          case '−':
            answer = first! - second;
            break;
          case '×':
            answer = first! * second;
            break;
          case '÷':
            if (second == 0) {
              display = 'Error';
              reset = true;
              return;
            }
            answer = first! / second;
            break;
          default:
            return;
        }

        display = answer % 1 == 0
            ? answer.toInt().toString()
            : answer.toStringAsFixed(2);

        widget.onHistory(display);
        first = null;
        operation = null;
        reset = true;
        return;
      }

      if (value == '.') {
        if (!display.contains('.')) display += '.';
        return;
      }

      if (reset || display == '0' || display == 'Error') {
        display = value;
        reset = false;
      } else {
        display += value;
      }
    });
  }

  Widget button(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 62,
          child: ElevatedButton(
            onPressed: () => press(text),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  ['+', '−', '×', '÷', 'C', '⌫'].contains(text)
                      ? Colors.blue.withValues(alpha: 0.10)
                      : text == '='
                          ? Colors.blue
                          : Colors.white,
              foregroundColor: text == '=' ? Colors.white : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130,
          padding: const EdgeInsets.all(22),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: FittedBox(
            child: Text(
              display,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [button('C'), button('⌫'), button('÷'), button('×')]),
        Row(children: [button('7'), button('8'), button('9'), button('−')]),
        Row(children: [button('4'), button('5'), button('6'), button('+')]),
        Row(children: [button('1'), button('2'), button('3'), button('=')]),
        Row(children: [button('0'), button('.')]),
      ],
    );
  }
}
