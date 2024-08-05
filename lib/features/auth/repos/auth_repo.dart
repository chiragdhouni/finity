// import 'dart:convert';
// import 'dart:developer';

// import 'package:finity/core/config/config.dart';
// import 'package:finity/features/auth/models/user_model.dart';
// import 'package:finity/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   // sign up user
//   Future<void> signUpUser({
//     required String email,
//     required String password,
//     required String name,
//     required String address,
//   }) async {
//     UserModel user = UserModel(
//       id: "",
//       name: name,
//       email: email,
//       password: password,
//       token: "",
//       address: address,
//       location: [],
//       itemsLended: [],
//       itemsBorrowed: [],
//       itemsRequested: [],
//     );
//     // log(jsonEncode(user.toJson()));
//     http.Response res = await http.post(
//       Uri.parse('${Config.serverURL}auth/register'),
//       body: user.toJson(),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     log(res.body);
//     if (res.statusCode != 201) {
//       log(res.statusCode.toString());
//       throw Exception(res.body);
//     }
//   }

//   // sign in user
//   Future<String> signInUser({
//     required String email,
//     required String password,
//     required context,
//   }) async {
//     log(jsonEncode({
//       'email': email,
//       'password': password,
//     }));
//     http.Response res = await http.post(
//       Uri.parse('${Config.serverURL}auth/login'),
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//       }),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//     );
//     log(res.body);
//     log(res.statusCode.toString());
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Provider.of<UserProvider>(context, listen: false).setUser(res.body);
//     await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

//     if (res.statusCode == 201) {
//       return "login successful";
//     }

//     return "login failed";
//   }

//   Future<void> getUserData(BuildContext context) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('x-auth-token');

//       // Set a default token if not found
//       if (token == null) {
//         token = '';
//         prefs.setString('x-auth-token', token);
//       }

//       // Check if the token is valid
//       var tokenRes = await http.get(
//         Uri.parse('${Config.serverURL}auth/tokenIsValid'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': token
//         },
//       );

//       if (tokenRes.statusCode == 200) {
//         var isTokenValid = jsonDecode(tokenRes.body);

//         if (isTokenValid == true) {
//           // Fetch user data if the token is valid
//           http.Response userRes = await http.get(
//             Uri.parse('${Config.serverURL}auth/user'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//               'x-auth-token': token
//             },
//           );

//           if (userRes.statusCode == 200) {
//             var userProvider =
//                 Provider.of<UserProvider>(context, listen: false);
//             log(userRes.body);
//             userProvider.setUser(userRes.body);
//             log(userProvider.user.toString());
//           } else {
//             log('Failed to fetch user data: ${userRes.statusCode}');
//           }
//         } else {
//           log('Token is invalid');
//         }
//       } else {
//         log('Failed to validate token: ${tokenRes.statusCode}');
//       }
//     } catch (e) {
//       log('Error: $e');
//     }
//   }
// }
import 'dart:convert';
import 'dart:developer';

import 'package:finity/core/config/config.dart';
import 'package:finity/features/auth/models/user_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Sign up user
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String address,
  }) async {
    UserModel user = UserModel(
      id: "",
      name: name,
      email: email,
      password: password,
      token: "",
      address: address,
      location: [], // Ensure location is initialized as a list
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
      log('Sign up response: ${res.body}');
      if (res.statusCode != 201) {
        log('Sign up failed with status: ${res.statusCode}');
        throw Exception('Failed to sign up: ${res.body}');
      }
    } catch (e) {
      log('Sign up error: $e');
      rethrow; // Propagate the error if needed
    }
  }

  Future<String> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    log('Attempting to sign in with email: $email');

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

      log('Sign in response: ${res.body}');
      log('Sign in status code: ${res.statusCode}');

      if (res.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser(res.body);

        // Store the token from the response
        await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
        log('Token stored: ${jsonDecode(res.body)['token']}');
        return "login successful";
      }

      return "login failed";
    } catch (e) {
      log('Sign in error: $e');
      return "login failed";
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      // Set a default token if not found
      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      // Check if the token is valid
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
          // Fetch user data if the token is valid
          http.Response userRes = await http.get(
            Uri.parse('${Config.serverURL}auth/user'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            },
          );

          if (userRes.statusCode == 201) {
            var userProvider =
                Provider.of<UserProvider>(context, listen: false);
            log('Fetched user data: ${userRes.body}');

            userProvider.setUser(userRes.body);
            log('UserProvider user: ${userProvider.user.toString()}');
          } else {
            log('Failed to fetch user data: ${userRes.statusCode}');
          }
        } else {
          log('Token is invalid');
        }
      } else {
        log('Failed to validate token: ${tokenRes.statusCode}');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }

  // Sign out user
  Future<void> logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('x-auth-token');
      log('${prefs.get('x-auth-token')}');
      Provider.of<UserProvider>(context, listen: false).logout();
    } catch (e) {
      log('Error signing out: $e');
    }
  }
}
