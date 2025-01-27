import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:flutter/material.dart';

class ManualAddParkingScreen extends StatelessWidget {
  const ManualAddParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DropSpotAppBar(title: "수동 등록"),
      body: SingleChildScrollView(
        child: Text("data"),
      ),
    );
  }
}
