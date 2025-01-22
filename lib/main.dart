import 'dart:async';

import 'package:dropspot/providers/parking_image_exif_provider.dart';
import 'package:dropspot/providers/parking_image_provider.dart';
import 'package:dropspot/providers/parking_recognized_text_provider.dart';
import 'package:dropspot/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

void main() {
  runZonedGuarded(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ParkingImageProvider()),
          ChangeNotifierProxyProvider<ParkingImageProvider,
              ParkingRecognizedTextProvider>(
            create: (_) => ParkingRecognizedTextProvider(),
            update: (_, parkingImageProvider, parkingRecognizedTextProvider) {
              parkingRecognizedTextProvider ??= ParkingRecognizedTextProvider();
              parkingRecognizedTextProvider
                  .setRecognizedText(parkingImageProvider.imagePath);
              return parkingRecognizedTextProvider;
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

class DropspotApp extends StatelessWidget {
  const DropspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Dropspot',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
      ),
      home: const HomeScreen(),
    );
  }
}
