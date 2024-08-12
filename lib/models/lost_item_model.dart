class LostItem {
  String id;
  String name;
  String description;
  String status;
  DateTime dateLost;
  String contactInfo;
  Owner owner;
  Location location;

  LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dateLost,
    required this.contactInfo,
    required this.owner,
    required this.location,
  });

  factory LostItem.fromJson(Map<String, dynamic> json) {
    // Provide default values if fields are null or missing
    return LostItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      dateLost: DateTime.tryParse(json['dateLost']) ?? DateTime.now(),
      contactInfo: json['contactInfo'] ?? '',
      owner: Owner.fromJson(json['owner']),
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    // Ensure id is not empty or null when sending to MongoDB
    return {
      '_id': id.isEmpty ? null : id,
      'name': name,
      'description': description,
      'status': status,
      'dateLost': dateLost.toIso8601String(),
      'contactInfo': contactInfo,
      'owner': owner.toJson(),
      'location': location.toJson(),
    };
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
