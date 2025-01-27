// ignore_for_file: constant_identifier_names

import 'package:dropspot/components/add_parking_image_button.dart';
import 'package:dropspot/components/image_datetime_text.dart';
import 'package:dropspot/components/image_viewer.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:dropspot/components/recognized_parking_level_text.dart';
import 'package:flutter/material.dart';

const HomeScreenLeftSpacer = SizedBox(width: 16);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddParkingImageButton(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageViewer(),
              SizedBox(height: 24),
              InfoCard(
                child: Column(
                  children: [
                    RecognizedParkingLevelText(),
                    ImageDateTimeText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
