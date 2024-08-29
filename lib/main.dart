import 'dart:developer';

import 'package:finity/design/theme/theme.dart';
import 'package:finity/blocs/auth/auth_bloc.dart';
import 'package:finity/services/auth_service.dart';
import 'package:finity/features/auth/ui/pages/login_page.dart';
import 'package:finity/blocs/event/ad_bloc.dart';
import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/features/home/bottom_nav_bar.dart';
import 'package:finity/services/event_service.dart';
import 'package:finity/services/item_service.dart';
import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/services/claim_lost_item_service.dart';
import 'package:finity/services/lost_item_service.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc

import 'package:finity/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            AuthService(userBloc: BlocProvider.of<UserBloc>(context)),
            BlocProvider.of<UserBloc>(context),
          ),
        ),
        BlocProvider<ItemBloc>(
          create: (context) => ItemBloc(ItemRepo()),
        ),
        BlocProvider<AdBloc>(
          create: (context) => AdBloc(EventRepo()),
        ),
        BlocProvider<LostItemBloc>(
          create: (context) => LostItemBloc(
            LostItemService(),
            ClaimLostItemRepo(context: context),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthService(userBloc: BlocProvider.of<UserBloc>(context));
    authService.getUserData(context); // Fetch user data
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          log('User loaded: ${state.user.name}');
          // Initialize the socket connection after user data is loaded
          BlocProvider.of<UserBloc>(context).add(InitializeSocket());
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded && state.user.id.isNotEmpty) {
            log(state.user.name);
            return MaterialApp(
              onGenerateRoute: (settings) => generateRoute(settings),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkThemeMode,
              home: BottomNavBar(),
            );
          } else if (state is UserLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkThemeMode,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return MaterialApp(
              onGenerateRoute: (settings) => generateRoute(settings),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkThemeMode,
              home: const LoginPage(),
            );
          }
        },
      ),
    );
  }
}
