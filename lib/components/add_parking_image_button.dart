import 'package:dropspot/screens/camera_screen.dart';
import 'package:flutter/material.dart';

class AddParkingImageButton extends StatelessWidget {
  const AddParkingImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(),
          ),
        );
      },
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
