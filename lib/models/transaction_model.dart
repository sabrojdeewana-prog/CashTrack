class CashTransaction {
  final int? id;
  final String type; // income | expense
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  const CashTransaction({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'category': category,
        'note': note,
        'date': date.toIso8601String(),
      };

  factory CashTransaction.fromMap(Map<String, Object?> map) {
    return CashTransaction(
      id: map['id'] as int?,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      note: (map['note'] as String?) ?? '',
      date: DateTime.parse(map['date'] as String),
    );
  }
}
