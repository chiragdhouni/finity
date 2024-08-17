import 'dart:async';
import 'package:finity/features/lost_item_screen/bloc/bloc/lost_item_bloc.dart';
import 'package:finity/features/lost_item_screen/ui/screens/display_nearby_item_screen.dart';
// import 'package:finity/models/user_model.dart';
// import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:finity/models/lost_item_model.dart';
import 'package:provider/provider.dart';

class LostItemScreen extends StatefulWidget {
  @override
  _LostItemScreenState createState() => _LostItemScreenState();
}

class _LostItemScreenState extends State<LostItemScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
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
        onPressed: () {
          // Navigate to AddLostItemScreen
          Navigator.of(context).pushNamed('/addLostItemScreen');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Lost Item',
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
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchLostItemSuccess) {
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
    );
  }

  Widget _buildNearbyItems() {
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
