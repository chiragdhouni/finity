// import 'package:finity/app.dart';

import 'dart:developer';

import 'package:finity/design/theme/theme.dart';
import 'package:finity/features/auth/bloc/auth_bloc.dart';
import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/auth/ui/pages/login_page.dart';
import 'package:finity/features/home/bloc/event_bloc/bloc/ad_bloc.dart';
import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/features/home/bottom_nav_bar.dart';
import 'package:finity/features/home/repos/event_repo.dart';
import 'package:finity/features/home/repos/home_repo.dart';
import 'package:finity/features/lost_item_screen/bloc/bloc/lost_item_bloc.dart';
import 'package:finity/features/lost_item_screen/repos/lost_item_repo.dart';

import 'package:finity/provider/user_provider.dart';

import 'package:finity/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(AuthService()),
          ),
          BlocProvider<ItemBloc>(
            create: (context) => ItemBloc(HomeRepo()),
          ),
          BlocProvider<AdBloc>(
            create: (context) => AdBloc(EventRepo()),
          ),
          BlocProvider<LostItemBloc>(
              create: (context) => LostItemBloc(LostItemService())),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    log(Provider.of<UserProvider>(context).user.id);
    return MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: Provider.of<UserProvider>(context).user.id.isNotEmpty
            ? BottomNavBar()
            : const LoginPage());
  }
}
