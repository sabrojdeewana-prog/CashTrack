import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../models/transaction_model.dart';

class CsvService {
  static String _escape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  static Future<bool> export(List<CashTransaction> items) async {
    final rows = <String>[
      'Date,Type,Category,Amount,Note',
    ];

    for (final e in items) {
      rows.add([
        _escape(e.date.toLocal().toString().split(' ').first),
        _escape(e.type),
        _escape(e.category),
        e.amount.toStringAsFixed(2),
        _escape(e.note),
      ].join(','));
    }

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save CashTrack CSV Report',
      fileName: 'cashtrack_report.csv',
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (path == null) return false;

    await File(path).writeAsString(rows.join('\n'));
    return true;
  }
}
