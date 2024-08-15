import 'package:finity/models/item_model.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/itemDetailScreen';
  final ItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.item
                .toMap()
                .map((key, value) => MapEntry(key, '$value\n'))
                .toString()),
          ],
        ),
      ),
    );
  }
}
