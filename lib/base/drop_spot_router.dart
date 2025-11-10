import 'package:dropspot/base/data/drop_spot_route.dart';
import 'package:dropspot/base/drop_spot_bottom_navigation_bar.dart';
import 'package:dropspot/screens/camera_screen.dart';
import 'package:dropspot/screens/home_screen.dart';
import 'package:dropspot/screens/manual_add_parking_screen.dart';
import 'package:dropspot/screens/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum DropSpotRouteItems {
  manualAddParkingScreen(
    DropSpotRoute(
      path: '/manual_add_parking_screen',
      screen: ManualAddParkingScreen(),
    ),
  ),
  cameraScreen(
    DropSpotRoute(
      path: '/camera_screen',
      screen: CameraScreen(),
    ),
  ),
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
          routes: DropSpotRouteItems.values
              .map(
                (element) => GoRoute(
                  path: element.item.path,
                  pageBuilder: (context, state) => MaterialPage(
                    child: element.item.screen,
                  ),
                ),
              )
              .toList())
    ],
  );
}
