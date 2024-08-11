// // ignore_for_file: prefer_const_constructors

// import 'dart:async';

// import 'package:finity/features/auth/bloc/auth_bloc.dart';
// import 'package:finity/features/auth/repos/auth_repo.dart';
// import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
// import 'package:finity/features/home/ui/widgets/card.dart';
// import 'package:finity/features/home/ui/widgets/event_slider.dart';
// import 'package:finity/features/home/ui/widgets/lost_item_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class App extends StatefulWidget {
//   final AuthService authService; // Pass in your AuthService
//   static const routeName = '/appScreen';

//   App({required this.authService});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => AuthBloc(widget.authService),
//         child: BlocListener<AuthBloc, AuthState>(
//             listener: (context, state) {
//               if (state is AuthInitial) {
//                 // Navigate to the login screen when the user is logged out
//                 setState(() {
//                   Navigator.of(context).pushReplacementNamed('/loginScreen');
//                 });
//               }
//               if (state is AuthErrorState) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(state.message),
//                   ),
//                 );
//               }
//               if (state is AuthLoading) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Loading...'),
//                   ),
//                 );
//               }
//             },
//             child: Scaffold(
//               appBar: AppBar(
//                 title: const Text(
//                   'Welcome to Finity',
//                   style: TextStyle(color: Colors.white, fontSize: 25),
//                 ),
//                 actions: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.logout,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       // Add logout functionality here
//                       context
//                           .read<AuthBloc>()
//                           .add(AuthLogoutEvent(context: context));
//                     },
//                   ),
//                 ],
//               ),
//               body: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20, left: 10, right: 10, bottom: 20),
//                 child: Column(
//                   children: [
//                     // ResponsiveCardLayout(),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     EventSlider(),
//                     SizedBox(
//                       height: 17,
//                     ),
//                     // Align(
//                     //   alignment: Alignment.centerLeft,
//                     //   child: Text(
//                     //     'Lost Items',
//                     //     style: TextStyle(
//                     //       fontSize: 20,
//                     //       fontWeight: FontWeight.bold,
//                     //     ),
//                     //   ),
//                     // ),
//                     // SizedBox(
//                     //   height: 10,
//                     // ),
//                     // LostItemList(),
//                   ],
//                 ),
//               ),
//             )));
//   }
// }

// class ItemSearchPage extends StatefulWidget {
//   @override
//   _ItemSearchPageState createState() => _ItemSearchPageState();
// }

// class _ItemSearchPageState extends State<ItemSearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (query.isEmpty) {
//         context
//             .read<ItemBloc>()
//             .add(SearchItemsEvent("")); // Trigger empty search
//       } else {
//         context.read<ItemBloc>().add(SearchItemsEvent(query));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Search Items')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Enter item name...',
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _onSearchChanged,
//             ),
//           ),
//           Expanded(
//             child: BlocBuilder<ItemBloc, ItemState>(
//               builder: (context, state) {
//                 if (state is ItemSearchLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (state is ItemSearchSuccess) {
//                   if (state.searchResults.isEmpty) {
//                     return Center(child: Text('No items found'));
//                   }
//                   return ListView.builder(
//                     itemCount: state.searchResults.length,
//                     itemBuilder: (context, index) {
//                       final item = state.searchResults[index];
//                       return Container(
//                         color: index % 2 == 0
//                             ? Colors.grey[200]
//                             : Colors.grey[300],
//                         child: ListTile(
//                           title: Text(item.name),
//                           subtitle: Text(item.description),
//                           onTap: () {
//                             // Handle item click to show details
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 } else if (state is ItemSearchError) {
//                   return Center(child: Text(state.error));
//                 }
//                 return Container(); // Return an empty container when initial state
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:finity/features/auth/bloc/auth_bloc.dart';
import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/features/home/ui/widgets/categories.dart';
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
  bool temp = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() {
        temp = false;
      });
    } else {
      setState(() {
        temp = true;
      });
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // EventSlider with fixed height
                EventSlider(),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter item name...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, state) {
                    if (state is ItemSearchLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ItemSearchSuccess) {
                      if (state.searchResults.isEmpty) {
                        return Center(child: Text('No items found'));
                      }
                      return temp
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Disable scrolling within ListView
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
                            )
                          : Container();
                    } else if (state is ItemSearchError) {
                      return Center(child: Text(state.error));
                    }
                    return Container(); // Return an empty container for initial state
                  },
                ),
                const SizedBox(height: 10),
                Categories(), // Static Categories section
                // Uncomment if you have additional widgets
                // ResponsiveCardLayout(),
                // const SizedBox(height: 15),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     'Lost Items',
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // LostItemList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
