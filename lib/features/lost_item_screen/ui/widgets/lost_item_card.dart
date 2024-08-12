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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LostItemDetail(
                      item: widget.item,
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]),
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

class LostItemDetail extends StatefulWidget {
  final LostItem item;
  const LostItemDetail({super.key, required this.item});

  @override
  State<LostItemDetail> createState() => _LostItemDetailState();
}

class _LostItemDetailState extends State<LostItemDetail> {
  @override
  Widget build(BuildContext context) {
    LostItem item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Container(
        child: Column(
          children: [
            Text(item.name),
            Text(item.description),
            Text(item.location.coordinates.first.toString()),
            Text(item.location.coordinates.last.toString()),
            Text(item.dateLost.toString()),
            Text(item.owner.address),
            Text(item.owner.email),
            Text(item.contactInfo),
          ],
        ),
      ),
    );
  }
}
