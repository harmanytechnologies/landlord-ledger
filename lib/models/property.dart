class Property {
  final String id;
  final String title;
  final String address;
  final String status; // e.g. "Occupied", "Vacant"
  final String? photoPath; // local file path or asset
  final String? notes;

  Property({
    required this.id,
    required this.title,
    required this.address,
    required this.status,
    this.photoPath,
    this.notes,
  });

  Property copyWith({
    String? id,
    String? title,
    String? address,
    String? status,
    String? photoPath,
    String? notes,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      status: status ?? this.status,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'status': status,
      'photoPath': photoPath,
      'notes': notes,
    };
  }

  factory Property.fromMap(Map<dynamic, dynamic> map) {
    return Property(
      id: map['id'] as String,
      title: map['title'] as String? ?? '',
      address: map['address'] as String? ?? '',
      status: map['status'] as String? ?? 'Vacant',
      photoPath: map['photoPath'] as String?,
      notes: map['notes'] as String?,
    );
  }
}


