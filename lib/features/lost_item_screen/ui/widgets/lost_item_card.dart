import 'package:finity/models/lost_item_model.dart';
import 'package:flutter/material.dart';

class LostItemCard extends StatefulWidget {
  final LostItem item;
  const LostItemCard({super.key, required this.item});

  @override
  State<LostItemCard> createState() => _LostItemCardState();
}

class _LostItemCardState extends State<LostItemCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: ListTile(
            title: Text(widget.item.name),
            subtitle: Text(
              widget.item.description,
              maxLines: 1, // Set the number of lines before fading
              overflow: TextOverflow.fade, // Apply the fade effect
              softWrap: false, // Prevent wrapping, so fading is noticeable
              style: TextStyle(
                color: Colors.white, // Customize the text style as needed
              ),
            )),
      ),
    );
  }
}
