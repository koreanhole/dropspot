import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/samples/sample.png',
      fit: BoxFit.cover, // 이미지 크기 조정
    );
  }
}
