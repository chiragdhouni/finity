import 'dart:convert';
import 'package:finity/models/address_model.dart'; // Assuming AddressModel is correctly imported

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
  final List<String>? images;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    this.images = const <String>[], // Default empty list if null
    required this.createdAt,
    required this.updatedAt,
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
      'dueDate': dueDate.toIso8601String(),
      'location': location.toMap(),
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as String,
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
      images: List<String>.from(map['images'] as List<dynamic>),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      //   address: AddressModel.fromMap(
      //       map['address'] as Map<String, dynamic>), // Parse address from map
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
  final AddressModel? address; // Change address to AddressModel

  Borrower({
    this.id,
    this.name,
    this.email,
    this.address, // Use AddressModel for address
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address?.toMap(), // Convert address to map
    };
  }

  factory Borrower.fromMap(Map<String, dynamic> map) {
    return Borrower(
      id: map['id'] as String?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      address: map['address'] != null
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null, // Parse address as AddressModel
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
  final AddressModel address; // Change address to AddressModel

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address, // Use AddressModel for address
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address.toMap(), // Convert address to map
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      address: AddressModel.fromMap(map['address']
          as Map<String, dynamic>), // Parse address as AddressModel
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);
}
