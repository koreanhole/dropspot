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
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: primaryColor),
          backgroundColor: backgroundColor,
        );
}
