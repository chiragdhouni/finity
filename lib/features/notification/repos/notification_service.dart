import 'dart:convert';

import 'package:finity/core/config/config.dart';
import 'package:finity/models/notification_model.dart';
import 'package:finity/provider/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NotificationService {
  final BuildContext context;

  NotificationService({required this.context});

  Future<List<NotificationModel>> getNotificationsForUserIds(
      List<String> notificationIds) async {
    final String token =
        Provider.of<UserProvider>(context, listen: false).user.token!;
    final String apiUrl =
        '${Config.serverURL}notification/getNotifications'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: jsonEncode({
        'notificationIds': notificationIds,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      return responseData
          .map((data) => NotificationModel.fromJson(data))
          .toList();
    } else {
      // log('Failed to fetch notifications: ${response.statusCode}');
      throw Exception('Failed to fetch notifications');
    }
  }
}
