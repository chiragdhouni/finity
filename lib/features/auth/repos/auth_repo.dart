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
  // sign up user
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
      location: {},
      itemsLended: [],
      itemsBorrowed: [],
      itemsRequested: [],
    );
    // log(jsonEncode(user.toJson()));
    http.Response res = await http.post(
      Uri.parse('${Config.serverURL}auth/register'),
      body: user.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    log(res.body);
    if (res.statusCode != 201) {
      log(res.statusCode.toString());
      throw Exception(res.body);
    }
  }

  // sign in user
  Future<String> signInUser({
    required String email,
    required String password,
    required context,
  }) async {
    log(jsonEncode({
      'email': email,
      'password': password,
    }));
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
    log(res.body);
    log(res.statusCode.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<UserProvider>(context, listen: false).setUser(res.body);
    await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

    if (res.statusCode == 201) {
      return "login successful";
    }

    return "login failed";
  }

// // sign in user
//   void signInUser({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       http.Response res = await http.post(
//         Uri.parse('${Config.serverURL}auth/login'),
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       );
//       log(res.body);
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           Provider.of<UserProvider>(context, listen: false).setUser(res.body);
//           await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             HomeScreen.routeName,
//             (route) => false,
//           );
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }

  // // get user data
  // Future<UserModel?> getUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('x-auth-token');

  //   if (token == null) {
  //     return null;
  //   }

  //   http.Response res = await http.post(
  //     Uri.parse('${Config.serverURL}auth/tokenIsValid'),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'x-auth-token': token,
  //     },
  //   );

  //   if (jsonDecode(res.body) == true) {
  //     http.Response userRes = await http.get(
  //       Uri.parse('${Config.serverURL}auth/user'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': token,
  //       },
  //     );

  //     return UserModel.fromJson(jsonDecode(userRes.body));
  //   }

  //   return null;
  // }
  // get user data

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
      var tokenRes = await http.get(
        Uri.parse('${Config.serverURL}auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      if (tokenRes.statusCode == 200) {
        var isTokenValid = jsonDecode(tokenRes.body);

        if (isTokenValid == true) {
          // Fetch user data if the token is valid
          http.Response userRes = await http.get(
            Uri.parse('${Config.serverURL}auth/user'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          );

          if (userRes.statusCode == 200) {
            var userProvider =
                Provider.of<UserProvider>(context, listen: false);
            log(userRes.body);
            userProvider.setUser(userRes.body);
            log(userProvider.user.toString());
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
      log('Error: $e');
    }
  }
}
