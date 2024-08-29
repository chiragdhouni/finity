import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc

class NearByItemScreen extends StatefulWidget {
  const NearByItemScreen({super.key});

  @override
  State<NearByItemScreen> createState() => _NearByItemScreenState();
}

class _NearByItemScreenState extends State<NearByItemScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the UserBloc to get user location
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      double latitude = userState.user.location[0];
      double longitude = userState.user.location[1];

      // Fetch nearby lost items
      BlocProvider.of<LostItemBloc>(context).add(
        getNearByLostItemsEvent(
          latitude: latitude,
          longitude: longitude,
          maxDistance: 10000.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items Near You', style: TextStyle(fontSize: 16)),
        BlocBuilder<LostItemBloc, LostItemState>(
          builder: (context, state) {
            if (state is LostItemLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NearByLostItemSuccess) {
              if (state.lostItems.isEmpty) {
                return Center(child: Text('No items found'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.lostItems.length,
                itemBuilder: (context, index) {
                  final item = state.lostItems[index];
                  return Container(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      onTap: () {
                        // Handle item click to show details
                      },
                    ),
                  );
                },
              );
            } else if (state is LostItemError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ],
    );
  }
}
