import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DropSpotAppBar(title: "더보기"),
      body: SafeArea(
        child: Center(
          child: Text('More Screen'),
        ),
      ),
    );
  }
}
