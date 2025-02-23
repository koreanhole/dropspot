import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DropSpotSnackBar {
  static void showSuccessSnackBar(BuildContext context, String message) {
    _showDropSpotSnackBar(
      context,
      message,
      Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
    );
  }

  static void showFailureSnackBar(BuildContext context, String message) {
    _showDropSpotSnackBar(
      context,
      message,
      Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }

  static void _showDropSpotSnackBar(
    BuildContext context,
    String message,
    Widget icon,
  ) {
    HapticFeedback.lightImpact();
    showTopSnackBar(
      Overlay.of(context),
      _DropSpotSnackBarContainer(
        message: message,
        icon: icon,
      ),
      padding: EdgeInsets.only(top: 8, left: 80, right: 80),
    );
  }
}

// ignore: must_be_immutable
class _DropSpotSnackBarContainer extends StatelessWidget {
  final String message;
  Widget icon;

  _DropSpotSnackBarContainer({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: tertiaryColor,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: darkGrey,
            offset: Offset(0, 8),
            spreadRadius: 1,
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Center(
                child: icon,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
