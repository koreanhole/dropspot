import 'package:dropspot/base/data/public_parking_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class PublicParkingLotInfoModalSheet extends StatelessWidget {
  final NMarker mapMarker;
  final PublicParkingInfo publicParkingInfo;

  const PublicParkingLotInfoModalSheet({
    super.key,
    required this.mapMarker,
    required this.publicParkingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
                Text(publicParkingInfo.toJson().toString()),
              ],
            ),
          )),
    );
  }
}
