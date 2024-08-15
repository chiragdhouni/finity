import 'package:finity/models/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;
  static const routeName = '/eventDetailScreen';
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert_sharp),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.event
                .toJson()
                .map((key, value) => MapEntry(key, '$value\n'))
                .toString()),
          ],
        ),
      ),
    );
  }
}
