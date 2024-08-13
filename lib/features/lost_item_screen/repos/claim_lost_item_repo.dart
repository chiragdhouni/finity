import 'dart:convert';
import 'dart:developer';

import 'package:finity/core/config/config.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ClaimLostItemRepo {
  final BuildContext context;

  ClaimLostItemRepo({required this.context});
  Future<void> submitClaim({
    required String lostItemId,
    required String proofText,
    required List<String> proofImages,
  }) async {
    final url = Uri.parse('${Config.serverURL}lostItems/claim/submit');
    final String token =
        Provider.of<UserProvider>(context, listen: false).user.token!;
    log('Token: $token');
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
        log('Claim submitted successfully');
      } else {
        log('Error submitting claim: ${response.body} ${response.statusCode}');
      }
    } catch (e) {
      log('Error submitting claim: $e');
    }
  }

  Future<void> acceptClaim(String claimId, String token) async {
    final url = Uri.parse('http://your-backend-url/api/accept-claim');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'claimId': claimId,
        }),
      );

      if (response.statusCode == 200) {
        log('Claim accepted successfully');
      } else {
        log('Error accepting claim: ${response.body}');
      }
    } catch (e) {
      log('An error occurred while accepting the claim: $e');
    }
  }

  Future<void> rejectClaim(String claimId, String token) async {
    final url = Uri.parse('http://your-backend-url/api/reject-claim');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'claimId': claimId,
        }),
      );

      if (response.statusCode == 200) {
        log('Claim rejected successfully');
      } else {
        log('Error rejecting claim: ${response.body}');
      }
    } catch (e) {
      log('An error occurred while rejecting the claim: $e');
    }
  }
}
