// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:finity/models/address_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token; // Made optional
  final String? profilePicture; // Made optional
  final String password;
  final AddressModel address; // Updated to use AddressModel
  final List<String> events;
  final List<NotificationModel>
      notifications; // Updated to use NotificationModel
  List<double> location; // Updated to List<double>
  final List<String> itemsLended;
  final List<String> itemsBorrowed;
  final List<String> itemsListed;
  final List<String> itemsRequested;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profilePicture,
    required this.password,
    required this.address, // AddressModel required
    required this.events,
    List<NotificationModel>? notifications, // Optional with default value
    List<double>? location, // Optional with default value
    required this.itemsListed,
    required this.itemsLended,
    required this.itemsBorrowed,
    required this.itemsRequested,
  })  : notifications = notifications ?? const [],
        location = location ?? const [0.0, 0.0];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'token': token,
      'profilePicture': profilePicture,
      'password': password,
      'address': address.toMap(), // Convert AddressModel to Map
      'location': {
        'type': 'Point',
        'coordinates': location,
      },
      'events': events,
      'notifications': notifications.map((n) => n.toMap()).toList(),
      'itemsListed': itemsListed,
      'itemsLended': itemsLended,
      'itemsBorrowed': itemsBorrowed,
      'itemsRequested': itemsRequested,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      token: map['token'] as String?,
      profilePicture: map['profilePicture'] as String?,
      password: map['password'] as String? ?? '',
      address: AddressModel.fromMap(
          map['address'] as Map<String, dynamic>), // Parse AddressModel
      location: map['location'] != null
          ? [
              (map['location']['coordinates'][0] as num).toDouble(),
              (map['location']['coordinates'][1] as num).toDouble(),
            ]
          : [0.0, 0.0],
      events: List<String>.from(map['events'] ?? []),
      notifications: (map['notifications'] as List<dynamic>? ?? [])
          .map((n) => NotificationModel.fromMap(n as Map<String, dynamic>))
          .toList(),
      itemsListed: List<String>.from(map['itemsListed'] ?? []),
      itemsLended: List<String>.from(map['itemsLended'] ?? []),
      itemsBorrowed: List<String>.from(map['itemsBorrowed'] ?? []),
      itemsRequested: List<String>.from(map['itemsRequested'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserModel.fromMap(json);
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? profilePicture,
    String? password,
    AddressModel? address, // Allow updating of AddressModel
    List<String>? events,
    List<double>? location,
    List<String>? itemsLended,
    List<String>? itemsBorrowed,
    List<String>? itemsListed,
    List<String>? itemsRequested,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profilePicture: profilePicture ?? this.profilePicture,
      password: password ?? this.password,
      address:
          address ?? this.address, // Use updated AddressModel or existing one
      events: events ?? this.events,
      notifications: notifications,
      location: location ?? this.location,
      itemsLended: itemsLended ?? this.itemsLended,
      itemsBorrowed: itemsBorrowed ?? this.itemsBorrowed,
      itemsListed: itemsListed ?? this.itemsListed,
      itemsRequested: itemsRequested ?? this.itemsRequested,
    );
  }
}

class NotificationModel {
  final String userId;
  final String? itemId;
  final String type;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.userId,
    this.itemId,
    required this.type,
    required this.message,
    this.read = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'itemId': itemId,
      'type': type,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      userId: map['userId'] as String? ?? '',
      itemId: map['itemId'] as String?,
      type: map['type'] as String? ?? '',
      message: map['message'] as String? ?? '',
      read: map['read'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(), // Fallback to current date if null
    );
  }

  NotificationModel copyWith({
    String? userId,
    String? itemId,
    String? type,
    String? message,
    bool? read,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
