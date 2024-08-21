import 'package:finity/features/notification/bloc/notification_bloc.dart';
import 'package:finity/features/notification/ui/widgets/notification_tile.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finity/features/notification/repos/notification_service.dart';

import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final notificationIds = userProvider.user.notifications;

    return BlocProvider(
      create: (context) => NotificationBloc(
        context,
        NotificationService(
            context:
                context), // Ensure you provide the actual implementation of NotificationService
      )..add(
          GetNotificationsEvent(notificationIds)), // Trigger the event with user ID(s)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationTile(notification: notification);
                },
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: const Text('No notifications'));
            }
          },
        ),
      ),
    );
  }
}
