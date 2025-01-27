import 'package:dropspot/base/theme/colors.dart';
import 'package:flutter/material.dart';

class DropSpotAppBar extends AppBar {
  DropSpotAppBar({
    super.key,
    required String title,
  }) : super(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: primaryColor),
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
        );
}
