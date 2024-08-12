import 'dart:async';
import 'package:finity/features/auth/bloc/auth_bloc.dart';
import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/features/home/ui/pages/display_items_screen.dart';
import 'package:finity/features/home/ui/widgets/event_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  final AuthService authService;

  App({required this.authService});
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
      create: (context) => AuthBloc(widget.authService),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            setState(() {
              Navigator.of(context).pushReplacementNamed('/loginScreen');
            });
          }
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is AuthLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Loading...'),
              ),
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
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
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
                  EventSlider(),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter item name...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<ItemBloc, ItemState>(
                    builder: (context, state) {
                      if (_isSearching) {
                        if (state is ItemSearchLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is ItemSearchSuccess) {
                          if (state.searchResults.isEmpty) {
                            return Center(child: Text('No items found'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.searchResults.length,
                            itemBuilder: (context, index) {
                              final item = state.searchResults[index];
                              return Container(
                                color: index % 2 == 0
                                    ? Colors.grey[200]
                                    : Colors.grey[300],
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
                        } else if (state is ItemSearchError) {
                          return Center(child: Text(state.error));
                        }
                        return Container(); // Return an empty container for initial state
                      } else {
                        // Show items near you if not searching
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Items Near You'),
                            DisplayItemsScreen(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
