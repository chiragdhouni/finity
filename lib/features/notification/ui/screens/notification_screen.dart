import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/notification/ui/widgets/notification_tile.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final List<NotificationModel> notifications =
                  state.user.notifications;

              if (notifications.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey[300]),
                itemBuilder: (context, index) {
                  return NotificationTile(notification: notifications[index]);
                },
              );
            } else if (state is UserError) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              );
            }
            return Container(); // Return empty container if state is not recognized
          },
        ),
      ),
    );
  }
}
