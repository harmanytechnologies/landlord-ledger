class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String? propertyId; // Optional: link to property
  final String type; // 'Rent Due', 'Inspection', 'Task', etc.
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.propertyId,
    required this.type,
    this.isCompleted = false,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? propertyId,
    String? type,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'propertyId': propertyId,
      'type': type,
      'isCompleted': isCompleted,
    };
  }

  factory Reminder.fromMap(Map<dynamic, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      date: map['date'] != null ? DateTime.parse(map['date'] as String) : DateTime.now(),
      propertyId: map['propertyId'] as String?,
      type: map['type'] as String? ?? 'Task',
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}

