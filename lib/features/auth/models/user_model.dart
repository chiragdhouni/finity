import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String? token; // Made optional
  String password;
  String address;
  List<double> location; // Updated to List<num>
  List<String> itemsLended;
  List<String> itemsBorrowed;
  List<String> itemsRequested;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    required this.password,
    required this.address,
    this.location = const [0.0, 0.0], // Default to [0.0, 0.0]
    required this.itemsLended,
    required this.itemsBorrowed,
    required this.itemsRequested,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'password': password,
      'address': address,
      'location': location,
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
              (map['location']['coordinates'][0]).toDouble(),
              (map['location']['coordinates'][1]).toDouble(),
            ]
          : [0.0, 0.0],
      itemsLended: List<String>.from(map['itemsLended'] ?? []),
      itemsBorrowed: List<String>.from(map['itemsBorrowed'] ?? []),
      itemsRequested: List<String>.from(map['itemsRequested'] ?? []),
    );
  }
  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userInfo = json['user'];
    return UserModel(
      id: json['user']['_id'] as String,
      name: json['user']['name'] as String,
      email: json['user']['email'] as String,
      token: json['token'] as String,
      address: json['user']['address'] as String,
      password: json['user']['password'] as String,
      location: List<double>.from(
          (json['user']['location']['coordinates'] as List)
              .map((x) => (x as num).toDouble())),
      itemsLended: List<String>.from(json['user']['itemsLended']),
      itemsBorrowed: List<String>.from(json['user']['itemsBorrowed']),
      itemsRequested: List<String>.from(json['user']['itemsRequested']),
    );
  }
}
