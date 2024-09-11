import 'package:finity/models/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  static const routeName = '/eventDetailScreen';

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_sharp),
            onPressed: () {
              // Implement alert functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Alert functionality not implemented')),
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
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Date: ${event.date.toLocal()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${event.location}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              // Display additional event details here
              // Example:
              // Text(
              //   'Additional Info: ${event.additionalInfo}',
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey[600],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
