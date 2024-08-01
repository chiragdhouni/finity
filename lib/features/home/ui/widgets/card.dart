import 'package:flutter/material.dart';

class ResponsiveCardLayout extends StatelessWidget {
  const ResponsiveCardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the total height of the screen
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // Add padding or other widgets here if needed
        SizedBox(
          height:
              screenHeight * 0.1, // Set the height to 10% of the screen height
          child: const Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Lend'),
                  ),
                ),
              ),
              SizedBox(width: 8.0), // Space between the two cards
              Expanded(
                child: Card(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Borrow'),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add more widgets here if needed
      ],
    );
  }
}
