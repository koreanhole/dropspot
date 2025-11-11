import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dropspot/base/activity_recognition_handler.dart';
import 'package:dropspot/base/drop_spot_router.dart';
import 'package:dropspot/base/flutter_channel/flutter_channel_helper.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
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
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initializeApplink();
    initializeActivityRecognition();
  }

  @override
  void dispose() {
    terminateApplink();
    super.dispose();
  }

  Future<void> initializeActivityRecognition() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ActivityRecognitionHandler().init();
    });
  }

  Future<void> initializeApplink() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _linkSubscription = AppLinks().uriLinkStream.listen(
        (uri) {
          Logger().d(uri);
          DropSpotRouter.routes.go('/${uri.host}');
        },
      );
    });
  }

  Future<void> initializeFlutterChannel() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        FlutterChannelHelper().registerHandler();
      },
    );
  }

  void terminateApplink() {
    _linkSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: DropSpotRouter.routes,
    );
  }
}
