import 'package:dropspot/base/data/parking_info.dart';
import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/string_util.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/providers/parking_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualAddParkingScreen extends StatelessWidget {
  const ManualAddParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double defaultManualParkingItemPadding = 16;

    const manualParkingItems = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4];

    return Scaffold(
      appBar: DropSpotAppBar(title: "주차 위치 추가"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultManualParkingItemPadding),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: defaultManualParkingItemPadding,
            mainAxisSpacing: defaultManualParkingItemPadding,
          ),
          itemCount: manualParkingItems.length,
          itemBuilder: (context, index) {
            return Material(
              color: secondaryColor,
              borderRadius: defaultBoxBorderRadius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  context.read<ParkingInfoProvider>().setParkingManualInfo(
                        ParkingInfo(
                          parkedLevel: manualParkingItems[index],
                          parkedDateTime: DateTime.now(),
                        ),
                      );
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    manualParkingItems[index].convertToReadableText(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
