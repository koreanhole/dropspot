import 'dart:async';

import 'package:dropspot/base/data/bottom_tab_item.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/providers/parking_image_exif_provider.dart';
import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:dropspot/providers/parking_level_text_provider.dart';
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
          ChangeNotifierProvider(create: (_) => ParkingImageProvider()),
          ChangeNotifierProxyProvider<ParkingImageProvider,
              ParkingLevelTextProvider>(
            create: (_) => ParkingLevelTextProvider(),
            update: (_, parkingImageProvider, parkingLevelTextProvider) {
              parkingLevelTextProvider ??= ParkingLevelTextProvider();
              parkingLevelTextProvider
                  .setRecognizedText(parkingImageProvider.imagePath);
              return parkingLevelTextProvider;
            },
          ),
          ChangeNotifierProxyProvider<ParkingImageProvider,
              ParkingImageExifProvider>(
            create: (_) => ParkingImageExifProvider(),
            update: (_, parkingImageProvider, parkingImageDateTimeProvider) {
              parkingImageDateTimeProvider ??= ParkingImageExifProvider();
              parkingImageDateTimeProvider
                  .setParkingImageExifData(parkingImageProvider.imagePath);
              return parkingImageDateTimeProvider;
            },
          ),
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
  int _selectedBottomTabIndex = 1;

  final List<BottomTabItem> _bottomTabItems = [
    BottomTabItem(
      label: '공영주차장',
      icon: Icon(Icons.map),
      screen: const ParkingMapScreen(),
    ),
    BottomTabItem(
      label: '홈',
      icon: Icon(Icons.home),
      screen: const HomeScreen(),
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
      theme: ThemeData(
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
