import 'dart:convert';

import 'package:finity/core/config/config.dart';
import 'package:finity/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserModel> getUserById() async {
    // Simulate a network request
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.get(
      Uri.parse('${Config.serverURL}user/getUserById'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
    );
    // log(response.body);
    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create lost item');
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.put(
      Uri.parse('${Config.serverURL}user/updateUser'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create lost item');
    }
  }
}
