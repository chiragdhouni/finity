import 'package:finity/features/notification/ui/widgets/notification_tile.dart';
import 'package:finity/models/user_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final List<NotificationModel> notification =
        userProvider.user.notifications;

    return ListView.builder(
      itemCount: notification.length,
      itemBuilder: (context, index) {
        return NotificationTile(notification: notification[index]);
      },
    );
  }
}
