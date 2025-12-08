class LedgerEntry {
  final String id;
  final String title;
  final double amount;
  final String? propertyId;
  final String type; // 'Income' or 'Expense'
  final DateTime date;
  final String? notes;

  LedgerEntry({
    required this.id,
    required this.title,
    required this.amount,
    this.propertyId,
    required this.type,
    required this.date,
    this.notes,
  });

  LedgerEntry copyWith({
    String? id,
    String? title,
    double? amount,
    String? propertyId,
    String? type,
    DateTime? date,
    String? notes,
  }) {
    return LedgerEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'propertyId': propertyId,
      'type': type,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory LedgerEntry.fromMap(Map<dynamic, dynamic> map) {
    return LedgerEntry(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      propertyId: map['propertyId'] as String?,
      type: map['type'] as String? ?? 'Expense',
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : DateTime.now(),
      notes: map['notes'] as String?,
    );
  }
}

