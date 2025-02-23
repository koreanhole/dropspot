// ignore_for_file: constant_identifier_names

import 'package:dropspot/base/drop_spot_router.dart';
import 'package:dropspot/base/extensions.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/dummy_recognized_parking_level_text.dart';
import 'package:dropspot/components/image_datetime_text.dart';
import 'package:dropspot/components/image_viewer.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:dropspot/components/recognized_parking_level_text.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

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
          _AddParkingImageSpotButton(context: context),
          _AddParkingManualSpotButton(context: context),
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

class _AddParkingManualSpotButton extends SpeedDialChild {
  _AddParkingManualSpotButton({required BuildContext context})
      : super(
          onTap: () async {
            if (context.mounted == false) {
              return;
            }
            DropSpotRouter.routes
                .push(DropSpotRouteItems.manualAddParkingScreen.item.path);
          },
          child: Icon(Icons.library_add),
          shape: CircleBorder(),
        );
}

class _AddParkingImageSpotButton extends SpeedDialChild {
  _AddParkingImageSpotButton({required BuildContext context})
      : super(
          onTap: () async {
            if (context.mounted == false) {
              return;
            }
            DropSpotRouter.routes
                .push(DropSpotRouteItems.cameraScreen.item.path);
          },
          child: Icon(Icons.add_a_photo),
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
                    onPressed: () => DropSpotRouter.routes.pop(context),
                    child: const Text("아니오"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await context
                          .read<ParkingInfoProvider>()
                          .deleteParkingInfo();
                      if (context.mounted) DropSpotRouter.routes.pop(context);
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
