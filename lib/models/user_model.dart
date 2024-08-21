import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String? token; // Made optional
  String password;
  String address;
  List<String> events;
  List<NotificationModel> notifications; // Updated to use NotificationModel
  List<double> location; // Updated to List<double>
  List<String> itemsLended;
  List<String> itemsBorrowed;
  List<String> itemsListed;
  List<String> itemsRequested;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.password,
    required this.address,
    required this.events,
    this.notifications = const [], // Default to empty list
    this.location = const [0.0, 0.0], // Default to [0.0, 0.0]
    required this.itemsListed,
    required this.itemsLended,
    required this.itemsBorrowed,
    required this.itemsRequested,
  });

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
      // location: map['location'] != null
      //     ? List<double>.from((map['location']['coordinates'] as List<dynamic>)
      //         .map((coord) => coord.toDouble()))
      //     : [0.0, 0.0],
      location: map['location'] != null
          ? [
              (map['location']['coordinates'][0]).toDouble(),
              (map['location']['coordinates'][1]).toDouble(),
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
  String userId;
  String? itemId;
  String type;
  String message;
  bool read;
  DateTime createdAt;

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
