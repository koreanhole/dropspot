import 'package:dropspot/base/data/bottom_tab_item.dart';
import 'package:dropspot/base/drop_spot_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DropSpotBottomNavigationBar extends StatelessWidget {
  DropSpotBottomNavigationBar({super.key});

  final List<BottomTabItem> _bottomTabItems = [
    BottomTabItem(
      label: '홈',
      icon: Icon(Icons.home),
      screen: DropSpotRouteItems.homeScreen.item.screen,
    ),
    BottomTabItem(
      label: '공영주차장',
      icon: Icon(Icons.map),
      screen: DropSpotRouteItems.parkingMapScreen.item.screen,
    ),
    BottomTabItem(
      label: '더보기',
      icon: Icon(Icons.more_horiz),
      screen: DropSpotRouteItems.moreScreen.item.screen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool _shouldShowBottomTab() {
      final String location = GoRouterState.of(context).uri.toString();
      return [
        DropSpotRouteItems.homeScreen.item.path,
        DropSpotRouteItems.parkingMapScreen.item.path,
        DropSpotRouteItems.moreScreen.item.path
      ].contains(location);
    }

    int _getCurrentIndex() {
      final String location = GoRouterState.of(context).uri.toString();
      if (location.startsWith(DropSpotRouteItems.homeScreen.item.path)) {
        return 0;
      }
      if (location.startsWith(DropSpotRouteItems.parkingMapScreen.item.path)) {
        return 1;
      }
      if (location.startsWith(DropSpotRouteItems.moreScreen.item.path)) {
        return 2;
      }
      return 0;
    }

    void _onBottomTabItemTapped(int index) {
      switch (index) {
        case 0:
          DropSpotRouter.routes.go(DropSpotRouteItems.homeScreen.item.path);
          break;
        case 1:
          DropSpotRouter.routes
              .go(DropSpotRouteItems.parkingMapScreen.item.path);
          break;
        case 2:
          DropSpotRouter.routes.go(DropSpotRouteItems.moreScreen.item.path);
          break;
      }
    }

    return _shouldShowBottomTab()
        ? BottomNavigationBar(
            currentIndex: _getCurrentIndex(),
            items: _bottomTabItems
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: item.icon,
                    label: item.label,
                  ),
                )
                .toList(),
            onTap: _onBottomTabItemTapped,
          )
        : SizedBox.shrink();
  }
}
