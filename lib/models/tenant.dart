class Tenant {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? propertyId; // Link to property
  final String? notes;

  Tenant({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.propertyId,
    this.notes,
  });

  Tenant copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? propertyId,
    String? notes,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      propertyId: propertyId ?? this.propertyId,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'propertyId': propertyId,
      'notes': notes,
    };
  }

  factory Tenant.fromMap(Map<dynamic, dynamic> map) {
    return Tenant(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      propertyId: map['propertyId'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

