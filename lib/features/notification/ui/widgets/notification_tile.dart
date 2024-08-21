import 'package:finity/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.message),
      subtitle: Text(notification.type),
      trailing: Icon(notification.read
          ? Icons.check_circle
          : Icons.radio_button_unchecked),
      onTap: () {
        // Handle notification tap (e.g., mark as read)
      },
    );
  }
}
