// ignore_for_file: public_member_api_docs, sort_constructors_first
class LostItem {
  String id;
  String name;
  String description;
  String status;
  DateTime dateLost;
  String contactInfo;
  List<String> claims;
  Owner owner;
  Location location;

  LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dateLost,
    required this.contactInfo,
    required this.claims,
    required this.owner,
    required this.location,
  });

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      dateLost: DateTime.tryParse(json['dateLost']) ?? DateTime.now(),
      contactInfo: json['contactInfo'] ?? '',
      claims: List<String>.from(json['claims'] ?? []),
      owner: Owner.fromJson(json['owner']),
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'name': name,
      'description': description,
      'status': status,
      'dateLost': dateLost.toIso8601String(),
      'contactInfo': contactInfo,
      'claims': claims,
      'owner': owner.toJson(),
      'location': location.toJson(),
    };
  }

  LostItem copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    DateTime? dateLost,
    String? contactInfo,
    List<String>? claims,
    Owner? owner,
    Location? location,
  }) {
    return LostItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      dateLost: dateLost ?? this.dateLost,
      contactInfo: contactInfo ?? this.contactInfo,
      claims: claims ?? this.claims,
      owner: owner ?? this.owner,
      location: location ?? this.location,
    );
  }
}

class Owner {
  String id;
  String name;
  String email;
  String address;

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }

  Owner copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
  }) {
    return Owner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
