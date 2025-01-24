import 'dart:async';

import 'package:dropspot/base/bottom_tab_item.dart';
import 'package:dropspot/providers/parking_image_exif_provider.dart';
import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:dropspot/providers/parking_level_text_provider.dart';
import 'package:dropspot/screens/camera_screen.dart';
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
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
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
