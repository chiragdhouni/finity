// import 'package:finity/app.dart';

import 'package:finity/design/theme/theme.dart';
import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/auth/ui/pages/login_page.dart';

import 'package:finity/features/home/home_screen.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:finity/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: MyApp()));
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
    return MaterialApp(
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: Provider.of<UserProvider>(context).user.id.isNotEmpty
            ? HomeScreen()
            : const LoginPage());
  }
}
