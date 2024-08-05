import 'dart:convert';

class ItemModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String status;
  final Owner owner;
  final Borrower? borrower;
  final DateTime dueDate;
  final Location location;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.owner,
    this.borrower,
    required this.dueDate,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'owner': owner.toMap(),
      'borrower': borrower?.toMap(),
      'dueDate': dueDate.toIso8601String(), // Convert DateTime to ISO string
      'location': location.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      status: map['status'] as String,
      owner: Owner.fromMap(map['owner'] as Map<String, dynamic>),
      borrower: map['borrower'] != null
          ? Borrower.fromMap(map['borrower'] as Map<String, dynamic>)
          : null,
      dueDate: DateTime.parse(map['dueDate'] as String),
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
    );
  }
}

class Location {
  final String type;
  final List<dynamic> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'coordinates': coordinates,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      type: map['type'] as String,
      coordinates: List<dynamic>.from(map['coordinates'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Borrower {
  final String id;
  final String name;
  final String email;
  final String address;

  Borrower({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }

  factory Borrower.fromMap(Map<String, dynamic> map) {
    return Borrower(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Borrower.fromJson(String source) =>
      Borrower.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Owner {
  final String id;
  final String name;
  final String email;
  final String address;

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);
}
