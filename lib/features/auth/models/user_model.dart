// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String password;
  final String email;
  final String location;
  final String token;
  final List<String> itemsLended;
  final List<String> itemsBorrowed;
  final List<String> itemsRequested;

  UserModel(
      {required this.id,
      required this.name,
      required this.password,
      required this.email,
      required this.token,
      required this.location,
      required this.itemsLended,
      required this.itemsBorrowed,
      required this.itemsRequested});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
      'token': token,
      'email': email,
      'location': location,
      'itemsLended': itemsLended,
      'itemsBorrowed': itemsBorrowed,
      'itemsRequested': itemsRequested,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      token: map['token'] ?? '',
      location: map['location'] ?? '',
      email: map['email'] ?? '',
      itemsLended: List<String>.from(map['itemsLended'] ?? []),
      itemsBorrowed: List<String>.from(map['itemsBorrowed'] ?? []),
      itemsRequested: List<String>.from(map['itemsRequested'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
