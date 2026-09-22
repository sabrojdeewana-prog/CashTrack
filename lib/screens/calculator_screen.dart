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

  String display = '0';
  String expression = '';

  double? firstNumber;
  String? operator;
  bool waitingForSecondNumber = false;
  bool justCalculated = false;

  double number(TextEditingController c) {
    return double.tryParse(c.text.trim()) ?? 0;
  }

  String formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(8)
        .replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void saveHistory(String text) {
    history.insert(0, text);
    if (history.length > 50) {
      history.removeLast();
    }
  }

  // ================= BASIC CALCULATOR =================

  void basicNumber(String value) {
    setState(() {
      if (display == 'Error' ||
          waitingForSecondNumber ||
          justCalculated) {
        display = value;
        waitingForSecondNumber = false;
        justCalculated = false;
      } else if (display == '0') {
        display = value;
      } else if (display.length < 16) {
        display += value;
      }
    });
  }

  void decimal() {
    setState(() {
      if (display == 'Error' ||
          waitingForSecondNumber ||
          justCalculated) {
        display = '0.';
        waitingForSecondNumber = false;
        justCalculated = false;
      } else if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  void deleteLast() {
    setState(() {
      if (display == 'Error' ||
          waitingForSecondNumber ||
          justCalculated) {
        display = '0';
        return;
      }

      if (display.length <= 1) {
        display = '0';
      } else {
        display = display.substring(0, display.length - 1);
      }
    });
  }

  void clearBasic() {
    setState(() {
      display = '0';
      expression = '';
      firstNumber = null;
      operator = null;
      waitingForSecondNumber = false;
      justCalculated = false;
    });
  }

  void toggleSign() {
    if (display == '0' || display == 'Error') return;

    setState(() {
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  void percentageBasic() {
    final value = double.tryParse(display);
    if (value == null) return;

    setState(() {
      display = formatNumber(value / 100);
    });
  }

  void basicOperator(String op) {
    final current = double.tryParse(display);
    if (current == null) return;

    setState(() {
      if (firstNumber != null &&
          operator != null &&
          !waitingForSecondNumber) {
        final calculated = calculateBasic(
          firstNumber!,
          current,
          operator!,
        );

        if (calculated == null) {
          display = 'Error';
          firstNumber = null;
          operator = null;
          return;
        }

        firstNumber = calculated;
        display = formatNumber(calculated);
      } else {
        firstNumber = current;
      }

      operator = op;
      expression = '${formatNumber(firstNumber!)} $op';
      waitingForSecondNumber = true;
      justCalculated = false;
    });
  }

  double? calculateBasic(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '−':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) return null;
        return a / b;
    }

    return null;
  }

  void basicEquals() {
    final secondNumber = double.tryParse(display);

    if (firstNumber == null ||
        operator == null ||
        secondNumber == null) {
      return;
    }

    final a = firstNumber!;
    final op = operator!;
    final b = secondNumber;

    final calculated = calculateBasic(a, b, op);

    setState(() {
      if (calculated == null) {
        display = 'Error';
        expression =
            '${formatNumber(a)} $op ${formatNumber(b)} =';
      } else {
        display = formatNumber(calculated);
        expression =
            '${formatNumber(a)} $op ${formatNumber(b)} =';

        saveHistory(
          '${formatNumber(a)} $op ${formatNumber(b)} = ${formatNumber(calculated)}',
        );
      }

      firstNumber = null;
      operator = null;
      waitingForSecondNumber = false;
      justCalculated = true;
    });
  }

  // ================= OTHER CALCULATORS =================

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
        text =
            '₹${formatNumber(value)} is $b% of ₹${formatNumber(a)}';
        break;

      case 2:
        value = a * b / 100;
        final total = a + value;

        text =
            'GST: ₹${formatNumber(value)} • Total: ₹${formatNumber(total)}';
        break;

      case 3:
        if (a <= 0 || r <= 0 || t <= 0) {
          text = 'Enter loan, interest and tenure';
        } else {
          final monthlyRate = r / 12 / 100;
          final months = t * 12;

          final power =
              math.pow(1 + monthlyRate, months).toDouble();

          final emi =
              a * monthlyRate * power / (power - 1);

          text =
              'Monthly EMI: ₹${formatNumber(emi)}';
        }
        break;

      case 4:
        final interest = a * r * t / 100;
        final total = a + interest;

        text =
            'Interest: ₹${formatNumber(interest)} • Total: ₹${formatNumber(total)}';
        break;

      case 5:
        if (a <= 0 || t < 0) {
          text = 'Enter valid amount and time';
        } else {
          final total =
              a * math.pow(1 + r / 100, t).toDouble();

          final interest = total - a;

          text =
              'Interest: ₹${formatNumber(interest)} • Total: ₹${formatNumber(total)}';
        }
        break;

      case 6:
        final profit = b - a;
        final percent = a == 0 ? 0 : profit / a * 100;

        text =
            '${profit >= 0 ? "Profit" : "Loss"}: ₹${formatNumber(profit.abs())} • ${formatNumber(percent.abs())}%';
        break;

      case 7:
        final discount = a * b / 100;
        final finalPrice = a - discount;

        text =
            'Discount: ₹${formatNumber(discount)} • Pay: ₹${formatNumber(finalPrice)}';
        break;

      case 8:
        final count = number(people);

        if (count <= 0) {
          text = 'Enter number of people';
        } else {
          final each = a / count;

          text =
              'Each person pays: ₹${formatNumber(each)}';
        }
        break;

      case 9:
        final saved = a * b / 100;

        text =
            'Monthly saving: ₹${formatNumber(saved)} • After saving: ₹${formatNumber(a - saved)}';
        break;

      case 10:
        if (a <= 0 || r <= 0 || t <= 0) {
          text = 'Enter loan, interest and tenure';
        } else {
          final monthlyRate = r / 12 / 100;
          final months = (t * 12).round();

          double balance = a;
          double totalInterest = 0;

          for (int i = 0; i < months; i++) {
            final interest = balance * monthlyRate;
            totalInterest += interest;

            balance -= a / months;

            if (balance < 0) {
              balance = 0;
            }
          }

          text =
              'Loan Schedule • Principal: ₹${formatNumber(a)} • Approx Interest: ₹${formatNumber(totalInterest)}';
        }
        break;

      case 11:
        final tax = a * b / 100;
        final total = a + tax;

        text =
            'Tax: ₹${formatNumber(tax)} • Total: ₹${formatNumber(total)}';
        break;

      default:
        return;
    }

    setState(() {
      result = text;

      if (text.isNotEmpty) {
        saveHistory(text);
      }
    });
  }

  void resetForm() {
    amount.clear();
    second.clear();
    rate.clear();
    time.clear();
    people.clear();

    setState(() {
      result = '';
    });
  }

  // ================= UI =================

  Widget basicButton(
    String text, {
    VoidCallback? onTap,
    bool wide = false,
  }) {
    return Expanded(
      flex: wide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget basicCalculator() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 28,
                child: Text(
                  expression,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            basicButton('AC', onTap: clearBasic),
            basicButton('⌫', onTap: deleteLast),
            basicButton('%', onTap: percentageBasic),
            basicButton('÷', onTap: () => basicOperator('÷')),
          ],
        ),

        Row(
          children: [
            basicButton('7', onTap: () => basicNumber('7')),
            basicButton('8', onTap: () => basicNumber('8')),
            basicButton('9', onTap: () => basicNumber('9')),
            basicButton('×', onTap: () => basicOperator('×')),
          ],
        ),

        Row(
          children: [
            basicButton('4', onTap: () => basicNumber('4')),
            basicButton('5', onTap: () => basicNumber('5')),
            basicButton('6', onTap: () => basicNumber('6')),
            basicButton('−', onTap: () => basicOperator('−')),
          ],
        ),

        Row(
          children: [
            basicButton('1', onTap: () => basicNumber('1')),
            basicButton('2', onTap: () => basicNumber('2')),
            basicButton('3', onTap: () => basicNumber('3')),
            basicButton('+', onTap: () => basicOperator('+')),
          ],
        ),

        Row(
          children: [
            basicButton('+/−', onTap: toggleSign),
            basicButton('0', onTap: () => basicNumber('0')),
            basicButton('.', onTap: decimal),
            basicButton('=', onTap: basicEquals),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            basicButton(
              '00',
              onTap: () => basicNumber('00'),
              wide: true,
            ),
            basicButton(
              'Clear',
              onTap: clearBasic,
              wide: true,
            ),
          ],
        ),
      ],
    );
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

  Widget toolForm() {
    switch (selected) {
      case 1:
        return Column(
          children: [
            input('Amount', amount),
            input('Percentage', second),
          ],
        );

      case 2:
        return Column(
          children: [
            input('Amount', amount),
            input('GST Rate %', second),
          ],
        );

      case 3:
        return Column(
          children: [
            input('Loan Amount', amount),
            input('Annual Interest %', rate),
            input('Tenure (Years)', time),
          ],
        );

      case 4:
      case 5:
        return Column(
          children: [
            input('Principal', amount),
            input('Rate %', rate),
            input('Time (Years)', time),
          ],
        );

      case 6:
        return Column(
          children: [
            input('Cost Price', amount),
            input('Selling Price', second),
          ],
        );

      case 7:
        return Column(
          children: [
            input('Original Price', amount),
            input('Discount %', second),
          ],
        );

      case 8:
        return Column(
          children: [
            input('Total Bill', amount),
            input('Number of People', people),
          ],
        );

      case 9:
        return Column(
          children: [
            input('Monthly Income', amount),
            input('Saving %', second),
          ],
        );

      case 10:
        return Column(
          children: [
            input('Loan Amount', amount),
            input('Annual Interest %', rate),
            input('Tenure (Years)', time),
          ],
        );

      case 11:
        return Column(
          children: [
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

  Widget _history() {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'No calculation history yet.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      children: history
          .map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(item),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBasic = selected == 0;
    final isHistory = selected == 12;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 58,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final active = selected == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: ChoiceChip(
                      label: Text(tools[index]),
                      selected: active,
                      onSelected: (_) {
                        setState(() {
                          selected = index;
                          result = '';
                        });

                        resetForm();
                      },
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: isBasic
                    ? basicCalculator()
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          if (!isHistory) ...[
                            toolForm(),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: calculate,
                                icon:
                                    const Icon(Icons.calculate),
                                label: const Text(
                                  'Calculate',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                            if (result.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(18),
                                  child: Text(
                                    result,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ] else
                            toolForm(),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
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
}
