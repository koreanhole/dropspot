import 'dart:async';

import 'package:dropspot/components/camera_button.dart';
import 'package:dropspot/components/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

void main() {
  runZonedGuarded(
    () => runApp(DropspotApp()),
    (error, stackTrace) {
      Logger().e('error: $error, stackTrace: $stackTrace');
    },
  );
}

class DropspotApp extends StatelessWidget {
  const DropspotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Dropspot"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageViewer(),
            CameraButton(),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
