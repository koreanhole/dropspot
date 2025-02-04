// ignore_for_file: constant_identifier_names

import 'package:dropspot/base/extensions.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/dummy_recognized_parking_level_text.dart';
import 'package:dropspot/components/image_datetime_text.dart';
import 'package:dropspot/components/image_viewer.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:dropspot/components/recognized_parking_level_text.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:dropspot/screens/camera_screen.dart';
import 'package:dropspot/screens/manual_add_parking_screen.dart';
import 'package:dropspot/screens/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const HomeScreenLeftSpacer = SizedBox(width: 16);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.edit,
        activeIcon: Icons.close,
        buttonSize: Size(56, 56),
        childrenButtonSize: Size(64, 64),
        overlayOpacity: 0.0,
        activeForegroundColor: primaryColor,
        activeBackgroundColor: secondaryColor,
        elevation: 3,
        spacing: 6,
        children: [
          _AddParkingSpotButton(context: context),
          _DeleteParkingSpotButton(context: context),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageViewer(),
              SizedBox(height: 24),
              context.watch<ParkingInfoProvider>().parkingInfo.letOrElse(
                    (it) => InfoCard(
                      child: Column(
                        children: [
                          RecognizedParkingLevelText(parkingInfo: it),
                          SizedBox(height: 12),
                          ImageDateTimeText(parkingInfo: it),
                        ],
                      ),
                    ),
                    orElse: () => InfoCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          DummyRecognizedParkingLevelText(),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _AddParkingSpotButton extends SpeedDialChild {
  _AddParkingSpotButton({required BuildContext context})
      : super(
          onTap: () async {
            final sharedPreferences = await SharedPreferences.getInstance();
            final isRecognizedTextEnalbed =
                sharedPreferences.getBool(recognizedTextStateKey) ??
                    recognizedTextStateDefaultValue;

            if (context.mounted == false) {
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isRecognizedTextEnalbed == true
                    ? CameraScreen()
                    : ManualAddParkingScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
          shape: CircleBorder(),
        );
}

class _DeleteParkingSpotButton extends SpeedDialChild {
  _DeleteParkingSpotButton({required BuildContext context})
      : super(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("주차 위치를 삭제할까요?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("아니오"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context
                          .read<ParkingInfoProvider>()
                          .deleteParkingInfo();
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    child: const Text(
                      "삭제",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Icon(Icons.delete),
          shape: CircleBorder(),
        );
}
