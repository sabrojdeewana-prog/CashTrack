import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  double? firstNumber;
  String? operation;
  bool resetDisplay = false;

  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        firstNumber = null;
        operation = null;
        resetDisplay = false;
        return;
      }

      if (value == '⌫') {
        if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
        return;
      }

      if (['+', '−', '×', '÷'].contains(value)) {
        firstNumber = double.tryParse(display);
        operation = value;
        resetDisplay = true;
        return;
      }

      if (value == '=') {
        final secondNumber = double.tryParse(display);
        if (firstNumber == null ||
            secondNumber == null ||
            operation == null) {
          return;
        }

        double result;

        switch (operation) {
          case '+':
            result = firstNumber! + secondNumber;
            break;
          case '−':
            result = firstNumber! - secondNumber;
            break;
          case '×':
            result = firstNumber! * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              display = 'Error';
              firstNumber = null;
              operation = null;
              resetDisplay = true;
              return;
            }
            result = firstNumber! / secondNumber;
            break;
          default:
            return;
        }

        display = result % 1 == 0
            ? result.toInt().toString()
            : result.toStringAsFixed(2);

        firstNumber = null;
        operation = null;
        resetDisplay = true;
        return;
      }

      if (value == '.') {
        if (!display.contains('.')) {
          display += '.';
        }
        return;
      }

      if (resetDisplay || display == '0' || display == 'Error') {
        display = value;
        resetDisplay = false;
      } else {
        display += value;
      }
    });
  }

  Widget button(
    String text, {
    bool operationButton = false,
    bool equalsButton = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 68,
          child: ElevatedButton(
            onPressed: () => press(text),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: equalsButton
                  ? Colors.blue
                  : operationButton
                      ? Colors.blue.withOpacity(0.12)
                      : Colors.white,
              foregroundColor:
                  equalsButton || operationButton ? Colors.blue : Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: equalsButton
                    ? Colors.white
                    : operationButton
                        ? Colors.blue
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF6F7FB),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Column(
                children: [
                  Row(children: [
                    button('C', operationButton: true),
                    button('⌫', operationButton: true),
                    button('÷', operationButton: true),
                    button('×', operationButton: true),
                  ]),
                  Row(children: [
                    button('7'),
                    button('8'),
                    button('9'),
                    button('−', operationButton: true),
                  ]),
                  Row(children: [
                    button('4'),
                    button('5'),
                    button('6'),
                    button('+', operationButton: true),
                  ]),
                  Row(children: [
                    button('1'),
                    button('2'),
                    button('3'),
                    button('=', equalsButton: true),
                  ]),
                  Row(children: [
                    button('0'),
                    button('.'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
