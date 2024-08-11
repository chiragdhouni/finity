// import 'package:flutter/material.dart';

// class Categories extends StatelessWidget {
//   const Categories({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 120.0, // Set a fixed height
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.count(
//           crossAxisCount: 2, // 2 cards in each row
//           crossAxisSpacing: 10.0,
//           mainAxisSpacing: 10.0,
//           children: const <Widget>[
//             CategoryCard(name: 'Electronics'),
//             CategoryCard(name: 'Services'),
//             CategoryCard(name: 'Tools'),
//             CategoryCard(name: 'Books'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   final String name;
//   const CategoryCard({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5.0,
//       child: Container(
//         color: Colors.blue,
//         padding: EdgeInsets.all(16.0),
//         alignment: Alignment.center,
//         child: Text(
//           name,
//           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
