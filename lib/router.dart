import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/services/auth_service.dart';
import 'package:finity/features/auth/ui/pages/login_page.dart';
import 'package:finity/features/auth/ui/pages/signup_page.dart';
import 'package:finity/features/home/bottom_nav_bar.dart';
import 'package:finity/features/home/ui/pages/display_items_screen.dart';
import 'package:finity/features/home/ui/pages/event_detail_screen.dart';
import 'package:finity/features/home/ui/pages/home_screen.dart';
import 'package:finity/features/home/ui/pages/item_detail_screen.dart';
import 'package:finity/features/lost_item_screen/ui/screens/add_lost_item_screen.dart';
import 'package:finity/features/lost_item_screen/ui/widgets/claim_item_form.dart';
import 'package:finity/features/notification/ui/screens/notification_detail_screen.dart';
import 'package:finity/models/event_model.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/models/lost_item_model.dart';

import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );

    case SignUpPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpPage(),
      );

    case BottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavBar(),
      );
    // case HomeScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => HomeScreen(),
    //   );
    case App.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => App(
          authService: AuthService(userBloc: UserBloc()),
        ),
      );
    // case ItemSearchPage.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => ItemSearchPage(),
    //   );

    case DisplayItemsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DisplayItemsScreen(),
      );

    case AddLostItemScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddLostItemScreen(),
      );

    case ClaimItemForm.routeName:
      final LostItem item = routeSettings.arguments as LostItem;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ClaimItemForm(item: item),
      );

    case EventDetailScreen.routeName:
      final EventModel event = routeSettings.arguments as EventModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EventDetailScreen(event: event),
      );

    case ItemDetailScreen.routeName:
      final ItemModel item = routeSettings.arguments as ItemModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ItemDetailScreen(item: item),
      );

    case NotificationDetailScreen.routeName:
      final NotificationModel notification =
          routeSettings.arguments as NotificationModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NotificationDetailScreen(notification: notification),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
