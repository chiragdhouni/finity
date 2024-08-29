import 'dart:convert';

import 'package:finity/core/config/config.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ClaimLostItemRepo {
  final BuildContext context;

  ClaimLostItemRepo({required this.context});
  Future<void> submitClaim({
    required String lostItemId,
    required String proofText,
    required List<String> proofImages,
  }) async {
    final url = Uri.parse('${Config.serverURL}lostItems/claim/submit');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    // Set a default token if not found
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    // log('Token: $token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // Assuming JWT for user authentication
        },
        body: jsonEncode({
          'lostItemId': lostItemId,
          'proofText': proofText,
          'proofImages': proofImages,
        }),
      );

      if (response.statusCode == 201) {
        // log('Claim submitted successfully');
      } else {
        // log('Error submitting claim: ${response.body} ${response.statusCode}');
      }
    } catch (e) {
      // log('Error submitting claim: $e');
    }
  }

  Future<void> acceptClaim(String claimId) async {
    final url = Uri.parse('${Config.serverURL}lostItems/claim/accept');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'claimId': claimId,
        }),
      );

      if (response.statusCode == 200) {
        // log('Claim accepted successfully');
      } else {
        // log('Error accepting claim: ${response.body}');
      }
    } catch (e) {
      // log('An error occurred while accepting the claim: $e');
    }
  }

  Future<void> rejectClaim(String claimId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final url = Uri.parse('${Config.serverURL}lostItems/claim/reject');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'claimId': claimId,
        }),
      );

      if (response.statusCode == 200) {
        // log('Claim rejected successfully');
      } else {
        // log('Error rejecting claim: ${response.body}');
      }
    } catch (e) {
      // log('An error occurred while rejecting the claim: $e');
    }
  }
}
