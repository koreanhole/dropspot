import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const moreScreenLabelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 16,
  color: Colors.black,
);

const moreScreenSublabelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: darkGrey,
);

const recognizedTextStateKey = "recognizedTextStateKey";
const recognizedTextStateDefaultValue = true;

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DropSpotAppBar(title: "더보기"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24),
              _RecognizedTextToggle(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecognizedTextToggle extends StatefulWidget {
  @override
  State<_RecognizedTextToggle> createState() => _RecognizedTextToggleState();
}

class _RecognizedTextToggleState extends State<_RecognizedTextToggle> {
  bool toggleValue = recognizedTextStateDefaultValue;

  @override
  void initState() {
    super.initState();
    initializeSharedPreference();
  }

  void initializeSharedPreference() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      toggleValue = preferences.getBool(recognizedTextStateKey) ??
          recognizedTextStateDefaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "주차위치 자동인식",
                style: moreScreenLabelTextStyle,
              ),
              SizedBox(height: 2),
              Text(
                "이미지에서 주차 위치를 자동으로 인식합니다.",
                style: moreScreenSublabelTextStyle,
              )
            ],
          ),
          CupertinoSwitch(
            activeTrackColor: primaryColor,
            value: toggleValue,
            onChanged: (value) async {
              final sharedPreferences = await SharedPreferences.getInstance();
              await sharedPreferences.setBool(recognizedTextStateKey, value);
              setState(() {
                toggleValue = value;
              });
            },
          )
        ],
      ),
    );
  }
}
