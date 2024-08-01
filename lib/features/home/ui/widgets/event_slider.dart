import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class EventSlider extends StatelessWidget {
  const EventSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 190.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: ['Event 1', 'Event 2', 'Event 3'].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: Text(
                  i,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
