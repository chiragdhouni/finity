import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? token; // Made optional
  final String password;
  final String address;
  final List<String> events;
  final List<NotificationModel>
      notifications; // Updated to use NotificationModel
  late final List<double> location; // Updated to List<double>
  final List<String> itemsLended;
  final List<String> itemsBorrowed;
  final List<String> itemsListed;
  final List<String> itemsRequested;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.password,
    required this.address,
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
      'password': password,
      'address': address,
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
      password: map['password'] as String? ?? '',
      address: map['address'] as String? ?? '',
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
}
