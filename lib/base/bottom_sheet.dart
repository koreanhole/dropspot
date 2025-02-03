import 'package:dropspot/base/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showDropSpotBottomsheet<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return showMaterialModalBottomSheet(
      context: context,
      duration: Duration(milliseconds: 100),
      backgroundColor: backgroundColor,
      expand: false,
      builder: (context) => child);
}
