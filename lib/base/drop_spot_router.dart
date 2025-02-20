import 'package:dropspot/base/data/drop_spot_route.dart';
import 'package:dropspot/base/drop_spot_bottom_navigation_bar.dart';
import 'package:dropspot/screens/home_screen.dart';
import 'package:dropspot/screens/more_screen.dart';
import 'package:dropspot/screens/parking_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum DropSpotRouteItems {
  homeScreen(
    DropSpotRoute(
      path: '/home_screen',
      screen: HomeScreen(),
    ),
  ),
  moreScreen(
    DropSpotRoute(
      path: '/more_screen',
      screen: MoreScreen(),
    ),
  ),
  parkingMapScreen(
    DropSpotRoute(
      path: '/parking_map_screen',
      screen: ParkingMapScreen(),
    ),
  );

  final DropSpotRoute item;
  const DropSpotRouteItems(this.item);
}

class DropSpotRouter {
  static final GoRouter routes = GoRouter(
    initialLocation: DropSpotRouteItems.homeScreen.item.path,
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: DropSpotBottomNavigationBar(),
          );
        },
        routes: [
          GoRoute(
            path: DropSpotRouteItems.homeScreen.item.path,
            builder: (BuildContext context, GoRouterState state) {
              return DropSpotRouteItems.homeScreen.item.screen;
            },
          ),
          GoRoute(
            path: DropSpotRouteItems.parkingMapScreen.item.path,
            builder: (BuildContext context, GoRouterState state) {
              return DropSpotRouteItems.parkingMapScreen.item.screen;
            },
          ),
          GoRoute(
            path: DropSpotRouteItems.moreScreen.item.path,
            builder: (BuildContext context, GoRouterState state) {
              return DropSpotRouteItems.moreScreen.item.screen;
            },
          )
        ],
      )
    ],
  );
}
