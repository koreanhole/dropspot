import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:flutter/material.dart';

class ManualAddParkingScreen extends StatelessWidget {
  const ManualAddParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double defaultManualParkingItemPadding = 16;

    return Scaffold(
      appBar: DropSpotAppBar(title: "수동 등록"),
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
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: defaultBoxBorderRadius,
                color: secondaryColor,
              ),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(
                    '지하 $index층',
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
