import 'package:finity/models/user_model.dart';
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
        // Navigate to the notification detail screen
        Navigator.of(context)
            .pushNamed('/notification-detail', arguments: notification);
      },
    );
  }
}
