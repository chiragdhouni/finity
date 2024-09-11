// ignore_for_file: unused_element, library_private_types_in_public_api

import 'dart:async';

import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/features/lost_item_screen/ui/screens/display_nearby_item_screen.dart';
import 'package:finity/features/lost_item_screen/ui/widgets/lost_item_card.dart';
import 'package:finity/models/user_model.dart';
// import 'package:finity/models/user_model.dart';
// import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:finity/models/lost_item_model.dart';

class LostItemScreen extends StatefulWidget {
  const LostItemScreen({super.key});

  @override
  _LostItemScreenState createState() => _LostItemScreenState();
}

class _LostItemScreenState extends State<LostItemScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  late UserBloc userBloc;
  late UserModel user;
  late LostItemBloc lostItemBloc;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    user = (userBloc.state as UserLoaded).user;
    lostItemBloc = BlocProvider.of<LostItemBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _debounce?.cancel();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
        });
        context
            .read<LostItemBloc>()
            .add(searchLostItemEvent(searchQuery: query));
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddLostItemScreen
          final isAdded =
              await Navigator.of(context).pushNamed('/addLostItemScreen');
          // if (isAdded != null) {
          //   lostItemBloc.add(getNearByLostItemsEvent(
          //       latitude: user.location[0],
          //       longitude: user.location[1],
          //       maxDistance: 10000.0));
          // }
        },
        tooltip: 'Add Lost Item',
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter lost item detail...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 10),
              _isSearching ? _buildSearchResults() : NearByItemScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<LostItemBloc, LostItemState>(
      builder: (context, state) {
        if (state is LostItemLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchLostItemSuccess) {
          if (state.lostItems.isEmpty) {
            return const Center(
              child: Text(
                'No items found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.lostItems.length,
            itemBuilder: (context, index) {
              final item = state.lostItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      item.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      LostItemDetailScreen.routeName,
                      arguments: item,
                    );
                  },
                ),
              );
            },
          );
        } else if (state is LostItemError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

//   Widget _buildNearbyItems() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Items Near You', style: TextStyle(fontSize: 16)),
//         BlocBuilder<LostItemBloc, LostItemState>(
//           builder: (context, state) {
//             if (state is LostItemLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is NearByLostItemSuccess) {
//               if (state.lostItems.isEmpty) {
//                 return Center(child: Text('No items found'));
//               }
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: state.lostItems.length,
//                 itemBuilder: (context, index) {
//                   final item = state.lostItems[index];
//                   return Container(
//                     color: Colors.red,
//                     child: ListTile(
//                       title: Text(item.name),
//                       subtitle: Text(item.description),
//                       onTap: () {
//                         // Handle item click to show details
//                         log('tapped');
//                         Navigator.of(context).pushNamed(
//                             LostItemDetailScreen.routeName,
//                             arguments: item);
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is LostItemError) {
//               return Center(child: Text(state.message));
//             }
//             return Container();
//           },
//         ),
//       ],
//     );
//   }
}
