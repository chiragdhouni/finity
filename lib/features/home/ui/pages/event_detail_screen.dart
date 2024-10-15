import 'package:finity/blocs/event/ad_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finity/models/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  static const routeName = '/eventDetailScreen';

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late UserModel currentUser;
  // Access current user details from UserBloc

  initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      currentUser = userState.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_sharp),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Alert functionality not implemented! Stay tuned...'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                widget.event.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),

              // Event Images (just showing count as placeholder)
              Text(
                '🎉 Images available: ${widget.event.image.length}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 8),

              // Event Description
              Text(
                widget.event.description,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Event Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '📅 Date: ${widget.event.date.toLocal()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Event Location
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '📍 Location: ${widget.event.address.city}, ${widget.event.address.state}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Check if the current user is the owner of the event
              if (currentUser.id == widget.event.owner.id) ...[
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Delete Button
                    ElevatedButton.icon(
                      onPressed: () {
                        _confirmDelete(context, widget.event.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text("Delete Event"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300]),
                    ),
                    // Update Button
                    ElevatedButton.icon(
                      onPressed: () {
                        _navigateToUpdateEvent(context, widget.event);
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Update Event"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Trigger the deletion in AdBloc
              context.read<AdBloc>().add(DeleteAdEvent(eventId: eventId));
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToUpdateEvent(BuildContext context, EventModel event) {
    // Navigate to update event screen
    Navigator.of(context).pushNamed(
      '/updateEventScreen',
      arguments: event,
    );
  }
}
