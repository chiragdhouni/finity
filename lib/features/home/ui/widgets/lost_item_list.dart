import 'package:flutter/material.dart';

class LostItemList extends StatelessWidget {
  LostItemList({super.key});
  // Sample data for lost items
  final List<String> lostItems = [
    'Lost Item 1',
    'Lost Item 2',
    'Lost Item 3',
    'Lost Item 4',
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: lostItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lostItems[index]),
          );
        },
      ),
    );
  }
}
