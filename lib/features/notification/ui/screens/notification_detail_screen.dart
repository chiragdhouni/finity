import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailScreen extends StatefulWidget {
  static const routeName = '/notification-detail';
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime createdAt = widget.notification
        .createdAt; // Assuming notification.createdAt is a DateTime object
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.notification.type),
            Text(widget.notification.message),
            Text(widget.notification.userId),
            Text(formattedDate),
            ElevatedButton(
                onPressed: () {},
                child: Text('lend the item to ${widget.notification.userId}')),
            ElevatedButton(onPressed: () {}, child: Text('reject the request'))
          ],
        ),
      ),
    );
  }
}
