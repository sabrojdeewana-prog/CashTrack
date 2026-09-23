import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class BackupService {
  static Future<bool> exportBackup() async {
    final transactions = await DatabaseHelper.instance.getAll();

    final data = {
      'app': 'CashTrack',
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'transactions': transactions.map((e) => e.toMap()).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(data);

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Save CashTrack Backup',
      fileName: 'cashtrack_backup.json',
      bytes: Uint8List.fromList(utf8.encode(json)),
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (path == null) return false;

    await File(path).writeAsString(json);
    return true;
  }

  static Future<int?> restoreBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.first;
    String json;

    if (picked.bytes != null) {
      json = utf8.decode(picked.bytes!);
    } else if (picked.path != null) {
      json = await File(picked.path!).readAsString();
    } else {
      throw Exception('Could not read backup file.');
    }

    final decoded = jsonDecode(json);

    if (decoded is! Map || decoded['app'] != 'CashTrack') {
      throw Exception('Invalid CashTrack backup file.');
    }

    final list = decoded['transactions'];

    if (list is! List) {
      throw Exception('Backup contains no transaction data.');
    }

    final transactions = <CashTransaction>[];

    for (final item in list) {
      if (item is! Map) {
        throw Exception('Invalid transaction data.');
      }

      transactions.add(
        CashTransaction.fromMap(
          Map<String, Object?>.from(item),
        ),
      );
    }

    await DatabaseHelper.instance.replaceAll(transactions);

    return transactions.length;
  }
}
