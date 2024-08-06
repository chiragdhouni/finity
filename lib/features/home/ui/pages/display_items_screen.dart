import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/features/home/models/item_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DisplayItemsScreen extends StatefulWidget {
  const DisplayItemsScreen({super.key});
  static const routeName = '/displayItemsScreen';

  @override
  State<DisplayItemsScreen> createState() => _DisplayItemsScreenState();
}

class _DisplayItemsScreenState extends State<DisplayItemsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double latitude =
        Provider.of<UserProvider>(context, listen: false).user.location[0];
    double longitude =
        Provider.of<UserProvider>(context, listen: false).user.location[1];

    context.read<ItemBloc>().add(FetchNearbyItemsEvent(
        latitude: latitude, longitude: longitude, maxDistance: 3000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          // _buildSearchBar(context),
          // _buildOptions(),
          Expanded(
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ItemFetched) {
                  return _buildItemList(state.data!);
                } else if (state is ItemError) {
                  return Center(child: Text(state.error));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

//  Widget _buildSearchBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search items...',
//           prefixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(),
//         ),
//         onChanged: (query) {
//           context.read<ItemBloc>().add(SearchItems(query));
//         },
//       ),
//     );
//   }

// Widget _buildOptions() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       ElevatedButton(
//         onPressed: () {
//           // Add functionality for sorting/filtering here
//         },
//         child: Text('Option 1'),
//       ),
//       SizedBox(width: 10),
//       ElevatedButton(
//         onPressed: () {
//           // Add functionality for sorting/filtering here
//         },
//         child: Text('Option 2'),
//       ),
//     ],
//   );
// }
Widget _buildItemList(List<ItemModel> items) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15.0),
            trailing: Text(
              item.dueDate.toString(),
              style: TextStyle(color: Colors.white70),
            ),
            tileColor: Colors.grey[850],
            title: Text(
              item.name,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white60),
            ),
            onTap: () {},
          ),
        ),
      );
    },
  );
}
