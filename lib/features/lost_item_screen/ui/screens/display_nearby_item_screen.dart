import 'package:finity/features/lost_item_screen/bloc/bloc/lost_item_bloc.dart';
import 'package:finity/features/lost_item_screen/ui/widgets/lost_item_card.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NearByItemScreen extends StatefulWidget {
  const NearByItemScreen({super.key});

  @override
  State<NearByItemScreen> createState() => _NearByItemScreenState();
}

class _NearByItemScreenState extends State<NearByItemScreen> {
  @override
  void initState() {
    // TODO: implement initState

    double latitude =
        Provider.of<UserProvider>(context, listen: false).user.location[0];
    double longitude =
        Provider.of<UserProvider>(context, listen: false).user.location[1];

    BlocProvider.of<LostItemBloc>(context).add(
      getNearByLostItemsEvent(
          latitude: latitude, longitude: longitude, maxDistance: 10000.0),
    );

    super.initState();
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
