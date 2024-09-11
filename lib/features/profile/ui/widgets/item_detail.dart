import 'package:finity/models/item_model.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatefulWidget {
  final ItemModel item;
  static const routeName = '/item-detail';

  const ItemDetail({super.key, required this.item});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Name
            Text(
              item.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Item Description
            Text(
              item.description,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Category
            Text(
              'Category: ${item.category}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Status
            Text(
              'Status: ${item.status}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Owner Information
            Text(
              'Owner: ${item.owner.name}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Email: ${item.owner.email}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Address: ${item.owner.address}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Borrower Information (if available)
            if (item.borrower != null) ...[
              Text(
                'Borrower: ${item.borrower!.name ?? 'N/A'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Email: ${item.borrower!.email ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Address: ${item.borrower!.address ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],

            // Due Date
            Text(
              'Due Date: ${item.dueDate.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Location
            Text(
              'Location: ${item.location.coordinates.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
