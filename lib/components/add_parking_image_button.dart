import 'package:dropspot/screens/camera_screen.dart';
import 'package:dropspot/screens/manual_add_parking_screen.dart';
import 'package:dropspot/screens/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddParkingImageButton extends StatelessWidget {
  const AddParkingImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final sharedPreferences = await SharedPreferences.getInstance();
        final isRecognizedTextEnalbed =
            sharedPreferences.getBool(recognizedTextStateKey) ??
                recognizedTextStateDefaultValue;

        if (context.mounted == false) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isRecognizedTextEnalbed == true
                ? CameraScreen()
                : ManualAddParkingScreen(),
          ),
        );
      },
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
