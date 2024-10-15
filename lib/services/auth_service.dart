import 'dart:convert';
import 'dart:developer';

import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/core/config/config.dart';
import 'package:finity/models/address_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final UserBloc userBloc;

  AuthService({required this.userBloc});

  // Sign up user
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required AddressModel address,
  }) async {
    UserModel user = UserModel(
      id: "",
      name: name,
      email: email,
      password: password,
      token: "",
      address: address,
      notifications: [],
      events: [],
      location: [],
      itemsListed: [],
      itemsLended: [],
      itemsBorrowed: [],
      itemsRequested: [],
    );

    try {
      http.Response res = await http.post(
        Uri.parse('${Config.serverURL}auth/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode != 201) {
        throw Exception('Failed to sign up: ${res.body}');
      }
      // Optionally, you can update the userBloc with the new user data
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Config.serverURL}auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Update UserBloc with user data
        userBloc.add(UpdateUser(res.body));

        // Store the token from the response
        await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
        log('token stored: ${jsonDecode(res.body)['token']}');
        return "login successful";
      }
      log('Sign in failed with status: ${res.statusCode}');
      log('Sign in failed with status: ${res.body}');
      return "error from server";
    } catch (e) {
      log('Sign in error: $e');
      return e.toString();
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      http.Response tokenRes = await http.get(
        Uri.parse('${Config.serverURL}auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (tokenRes.statusCode == 200) {
        bool isTokenValid = jsonDecode(tokenRes.body);

        if (isTokenValid) {
          http.Response userRes = await http.get(
            Uri.parse('${Config.serverURL}auth/user'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            },
          );

          if (userRes.statusCode == 201 || userRes.statusCode == 200) {
            // Update UserBloc with user data
            userBloc.add(UpdateUser(userRes.body));
          }
        }
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');
      userBloc.add(LogoutUser());
    } catch (e) {
      log('Error signing out: $e');
    }
  }
}
