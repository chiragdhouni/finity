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

import 'package:finity/provider/user_provider.dart';

import 'package:finity/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

//afdlhasdfjh
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
            create: (context) => ItemBloc(ItemRepo()),
          ),
          BlocProvider<AdBloc>(
            create: (context) => AdBloc(EventRepo()),
          ),
          BlocProvider<LostItemBloc>(
              create: (context) => LostItemBloc(
                  LostItemService(), ClaimLostItemRepo(context: context))),
          // BlocProvider<NotificationBloc>(
          //   create: (context) => NotificationBloc(
          //       context, NotificationService(context: context)),
          // )
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    // log(Provider.of<UserProvider>(context).user.id);
    return MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: Provider.of<UserProvider>(context).user.id.isNotEmpty
            ? BottomNavBar()
            : const LoginPage());
  }
}
