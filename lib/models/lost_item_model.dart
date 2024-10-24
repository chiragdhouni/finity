// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:finity/models/address_model.dart'; // Assuming you have AddressModel

// LostItem Model
class LostItem {
  String id;
  String name;
  String description;
  String status;
  DateTime dateLost;
  String contactInfo;
  List<String> claims;
  List<String> images;
  Owner owner;
  Location location;
  AddressModel address;

  LostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dateLost,
    required this.contactInfo,
    required this.claims,
    this.images = const [],
    required this.owner,
    required this.location,
    required this.address,
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
      images: List<String>.from(json['images'] ?? []),
      owner: Owner.fromJson(
          json['owner']), // Ensure this is correctly parsed as Owner
      location:
          Location.fromJson(json['location']), // Correctly parse as Location
      address: AddressModel.fromJson(
          json['address']), // Correctly parse as AddressModel
    );
  }

  // Method to convert LostItem to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id.isEmpty ? null : id,
      'name': name,
      'description': description,
      'status': status,
      'dateLost': dateLost.toIso8601String(),
      'contactInfo': contactInfo,
      'claims': claims,
      'images': images,
      'owner': owner.toJson(),
      'location': location.toJson(),
      'address': address.toJson(),
    };
  }

  // Method to create a copy of LostItem with updated fields
  LostItem copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    DateTime? dateLost,
    String? contactInfo,
    List<String>? claims,
    List<String>? images,
    Owner? owner,
    Location? location,
    AddressModel? address,
  }) {
    return LostItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      dateLost: dateLost ?? this.dateLost,
      contactInfo: contactInfo ?? this.contactInfo,
      claims: claims ?? this.claims,
      images: images ?? this.images,
      owner: owner ?? this.owner,
      location: location ?? this.location,
      address: address ?? this.address,
    );
  }
}

// Owner Model
class Owner {
  String id;
  String name;
  String email;
  AddressModel address;

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  // Factory method to create Owner from JSON
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: AddressModel.fromJson(json['address']),
    );
  }

  // Method to convert Owner to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toJson(),
    };
  }

  // Method to create a copy of Owner with updated fields
  Owner copyWith({
    String? id,
    String? name,
    String? email,
    AddressModel? address,
  }) {
    return Owner(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}

// Location Model
class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  // Factory method to create Location from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }

  // Method to convert Location to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  // Method to create a copy of Location with updated fields
  Location copyWith({
    String? type,
    List<double>? coordinates,
  }) {
    return Location(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}
