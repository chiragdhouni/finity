import 'dart:convert';
import 'package:finity/models/address_model.dart'; // Assuming AddressModel is correctly imported

class ItemModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String status;
  final Owner owner;
  final Borrower? borrower; // Nullable borrower
  final DateTime dueDate;
  final Location location;
  final List<String>? images;
  final DateTime? createdAt; // Nullable createdAt
  final DateTime? updatedAt; // Nullable updatedAt

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.owner,
    this.borrower, // Nullable borrower
    required this.dueDate,
    required this.location,
    this.images = const <String>[], // Default empty list if null
    this.createdAt, // Nullable
    this.updatedAt, // Nullable
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'status': status,
      'owner': owner.toMap(),
      'borrower': borrower?.toMap(), // Nullable borrower
      'dueDate': dueDate.toIso8601String(),
      'location': location.toMap(),
      'images': images,
      'createdAt': createdAt?.toIso8601String(), // Nullable
      'updatedAt': updatedAt?.toIso8601String(), // Nullable
    };
  }

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
          : null, // Safely handle null borrower
      dueDate: DateTime.parse(map['dueDate'] as String),
      location: Location.fromMap(map['location'] as Map<String, dynamic>),
      images: map['images'] != null
          ? List<String>.from(map['images'])
          : <String>[], // Default to empty list if images are null
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null, // Handle missing createdAt
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null, // Handle missing updatedAt
    );
  }

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
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
  final String? id;
  final String? name;
  final String? email;
  final AddressModel? address; // Nullable AddressModel

  Borrower({
    this.id,
    this.name,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address?.toMap(), // Nullable address
    };
  }

  factory Borrower.fromMap(Map<String, dynamic> map) {
    return Borrower(
      id: map['id'] as String?, // Nullable id
      name: map['name'] as String?, // Nullable name
      email: map['email'] as String?, // Nullable email
      address: map['address'] != null
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null, // Handle null address
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
  final AddressModel address; // AddressModel

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address, // AddressModel required
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address.toMap(), // AddressModel to map
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);
}
