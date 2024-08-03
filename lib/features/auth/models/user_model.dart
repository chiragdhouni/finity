import 'dart:convert';

class UserModel {
  String id;
  String name;
  String email;
  String? token; // Made optional
  String password;
  String address;
  Map<String, dynamic> location; // Updated to Map<String, dynamic>
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
    this.location = const {}, // Default to empty map
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
      location: map['location'] as Map<String, dynamic>? ?? {},
      itemsLended: List<String>.from(map['itemsLended'] ?? []),
      itemsBorrowed: List<String>.from(map['itemsBorrowed'] ?? []),
      itemsRequested: List<String>.from(map['itemsRequested'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
