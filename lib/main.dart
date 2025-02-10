import 'dart:async';

import 'package:dropspot/base/data/bottom_tab_item.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:dropspot/screens/home_screen.dart';
import 'package:dropspot/screens/more_screen.dart';
import 'package:dropspot/screens/parking_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

void main() {
  runZonedGuarded(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ParkingInfoProvider()),
        ],
        child: const DropspotApp(),
      ),
    ),
    (error, stackTrace) {
      Logger().e('error: $error, stackTrace: $stackTrace');
    },
  );
}

class DropspotApp extends StatefulWidget {
  const DropspotApp({super.key});

  @override
  State<DropspotApp> createState() => _DropspotAppState();
}

class _DropspotAppState extends State<DropspotApp> {
  int _selectedBottomTabIndex = 0;

  final List<BottomTabItem> _bottomTabItems = [
    BottomTabItem(
      label: '홈',
      icon: Icon(Icons.home),
      screen: const HomeScreen(),
    ),
    BottomTabItem(
      label: '공영주차장',
      icon: Icon(Icons.map),
      screen: const ParkingMapScreen(),
    ),
    BottomTabItem(
      label: '더보기',
      icon: Icon(Icons.more_horiz),
      screen: const MoreScreen(),
    ),
  ];

  void _onBottomTabItemTapped(int index) {
    setState(() {
      _selectedBottomTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropspot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: primaryColor,
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: primaryColor,
          selectedIconTheme: const IconThemeData(size: 24),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          unselectedIconTheme: const IconThemeData(size: 24),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: primaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: primaryColor,
          backgroundColor: secondaryColor,
          elevation: 3,
          highlightElevation: 3,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      home: Scaffold(
        body: _bottomTabItems[_selectedBottomTabIndex].screen,
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomTabItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.label,
                ),
              )
              .toList(),
          currentIndex: _selectedBottomTabIndex,
          onTap: _onBottomTabItemTapped,
        ),
      ),
    );
  }
}
