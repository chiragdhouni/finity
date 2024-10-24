import 'dart:async';
import 'package:finity/blocs/auth/auth_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/services/auth_service.dart';
import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/features/home/ui/pages/display_items_screen.dart';
import 'package:finity/features/home/ui/pages/item_detail_screen.dart';
import 'package:finity/features/home/ui/widgets/card.dart';
import 'package:finity/features/home/ui/widgets/event_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  final AuthService authService;

  const App({super.key, required this.authService});
  static const routeName = '/appScreen';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      _isSearching = query.isNotEmpty;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_isSearching) {
        context.read<ItemBloc>().add(SearchItemsEvent(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        AuthService(userBloc: BlocProvider.of<UserBloc>(context)),
        BlocProvider.of<UserBloc>(context),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushReplacementNamed('/loginScreen');
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading...')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Welcome to Finity',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthLogoutEvent(context: context));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ResponsiveCardLayout(),
                  const SizedBox(height: 15),
                  const EventSlider(),
                  const SizedBox(height: 15),
                  _buildSearchField(),
                  const SizedBox(height: 10),
                  CategoryRow(),
                  const SizedBox(height: 10),
                  _buildSearchResults(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Enter item name...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: _onSearchChanged,
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (_isSearching) {
          if (state is ItemSearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemSearchSuccess) {
            if (state.searchResults.isEmpty) {
              return const Center(child: Text('No items found'));
            }
            return _buildItemList(state);
          } else if (state is ItemSearchError) {
            return Center(child: Text(state.error));
          }
        } else {
          return _buildItemsNearYou();
        }
        return Container();
      },
    );
  }

  Widget _buildItemList(ItemSearchSuccess state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final item = state.searchResults[index];
        return Container(
          color: index % 2 == 0 ? Colors.grey[200] : Colors.grey[300],
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
            onTap: () {
              Navigator.of(context).pushNamed(
                ItemDetailScreen.routeName,
                arguments: item,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItemsNearYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text('Items Near You',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        DisplayItemsScreen(),
      ],
    );
  }
}

class CategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryIcon(Icons.electric_bolt, "electronics"),
          _buildCategoryIcon(Icons.pan_tool_sharp, "Tools"),
          _buildCategoryIcon(Icons.power, "Games"),
          _buildCategoryIcon(Icons.local_pizza, "Pizza"),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData iconData, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orangeAccent, // Color of the circle
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 30,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
