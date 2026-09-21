import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/transaction_model.dart';

class PdfService {
  static Future<void> createAndPrint(
    List<CashTransaction> items, {
    String title = 'CashTrack Report',
  }) async {
    final doc = pw.Document();

    final income = items
        .where((e) => e.type == 'income')
        .fold<double>(0, (sum, e) => sum + e.amount);

    final expense = items
        .where((e) => e.type == 'expense')
        .fold<double>(0, (sum, e) => sum + e.amount);

    final balance = income - expense;

    doc.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Total Income: ₹${income.toStringAsFixed(2)}'),
          pw.Text('Total Expenses: ₹${expense.toStringAsFixed(2)}'),
          pw.Text('Balance: ₹${balance.toStringAsFixed(2)}'),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: [
              'Date',
              'Type',
              'Category',
              'Amount',
              'Note',
            ],
            data: items.map((e) {
              return [
                e.date.toLocal().toString().split(' ').first,
                e.type,
                e.category,
                e.amount.toStringAsFixed(2),
                e.note,
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final Uint8List bytes = await doc.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'cashtrack_report.pdf',
    );
  }
}
