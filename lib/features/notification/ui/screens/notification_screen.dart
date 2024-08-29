import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/notification/ui/widgets/notification_tile.dart';
import 'package:finity/models/notification_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final List<NotificationModel> notifications =
              state.user.notifications;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationTile(notification: notifications[index]);
            },
          );
        } else if (state is UserError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Container(); // Return empty container if state is not recognized
      },
    );
  }
}
