class Expense {
  final String id;
  final String title;
  final double amount;
  final String? propertyId; // Link to property
  final String category; // e.g. "Maintenance", "Utilities", "Repairs", etc.
  final DateTime date;
  final String? notes;
  final String? receiptPath; // local file path for receipt image

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    this.propertyId,
    required this.category,
    required this.date,
    this.notes,
    this.receiptPath,
  });

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? propertyId,
    String? category,
    DateTime? date,
    String? notes,
    String? receiptPath,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      propertyId: propertyId ?? this.propertyId,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptPath: receiptPath ?? this.receiptPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'propertyId': propertyId,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'receiptPath': receiptPath,
    };
  }

  factory Expense.fromMap(Map<dynamic, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      propertyId: map['propertyId'] as String?,
      category: map['category'] as String? ?? 'Other',
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : DateTime.now(),
      notes: map['notes'] as String?,
      receiptPath: map['receiptPath'] as String?,
    );
  }
}
