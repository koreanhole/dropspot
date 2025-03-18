import 'dart:io';

import 'package:dropspot/base/bottom_sheet.dart';
import 'package:dropspot/base/drop_spot_app_bar.dart';
import 'package:dropspot/base/drop_spot_horizontal_page_view.dart';
import 'package:dropspot/base/drop_spot_snack_bar.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logger/web.dart';
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
const recognizedTextStateDefaultValue = false;

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
              // _RecognizedTextToggle(),
              // SizedBox(height: 16),
              _AppRating(),
              if (Platform.isIOS) ...[
                SizedBox(height: 16),
                _IOSWidgetIntroduction()
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IOSWidgetIntroductionItem extends StatelessWidget {
  final String introductionImagePath;
  final String introductionDescription;

  const _IOSWidgetIntroductionItem({
    required this.introductionImagePath,
    required this.introductionDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Container(
            height: 600,
            decoration: BoxDecoration(
              borderRadius: defaultBoxBorderRadius,
              image: DecorationImage(
                image: AssetImage(
                  introductionImagePath,
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          introductionDescription,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _IOSWidgetIntroduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDropSpotBottomsheet(
          context: context,
          child: SafeArea(
            child: DropSpotHorizontalPageView(
              pages: [
                _IOSWidgetIntroductionItem(
                  introductionImagePath:
                      "assets/images/ios_widget_introduction/widget_introduction_1.png",
                  introductionDescription: "잠금화면을 꾹 눌러 주차의 도사 위젯을 찾아보세요.",
                ),
                _IOSWidgetIntroductionItem(
                  introductionImagePath:
                      "assets/images/ios_widget_introduction/widget_introduction_2.png",
                  introductionDescription: "주차의 도사 위젯을 잠금화면에 추가해보세요.",
                ),
                _IOSWidgetIntroductionItem(
                  introductionImagePath:
                      "assets/images/ios_widget_introduction/widget_introduction_3.png",
                  introductionDescription: "잠금화면에서 빠르게 주차 위치를 확인해보세요.",
                ),
              ],
            ),
          ),
        );
      },
      child: InfoCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "잠금화면에 위젯을 추가해 보세요.",
                  style: moreScreenLabelTextStyle,
                ),
                SizedBox(height: 2),
                Text(
                  "빠르게 주차 위치를 확인하고 기록할 수 있습니다.",
                  style: moreScreenSublabelTextStyle,
                )
              ],
            ),
            Icon(
              Icons.open_in_browser_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final inAppReviewInstance = InAppReview.instance;
        if (await inAppReviewInstance.isAvailable()) {
          inAppReviewInstance.requestReview();
        } else {
          Logger().e("In app reivew is not available");
          if (context.mounted == true) {
            DropSpotSnackBar.showFailureSnackBar(context, "리뷰를 남길 수 없습니다.");
          }
          inAppReviewInstance.openStoreListing(appStoreId: "6741436582");
        }
      },
      child: InfoCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "앱을 평가해주세요.",
                  style: moreScreenLabelTextStyle,
                ),
                SizedBox(height: 2),
                Text(
                  "사용하면서 만족했던 점, 불편한 점에 대해 피드백해 주세요.",
                  style: moreScreenSublabelTextStyle,
                )
              ],
            ),
            Icon(
              Icons.open_in_new_outlined,
            ),
          ],
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
                "주차 위치 자동인식",
                style: moreScreenLabelTextStyle,
              ),
              SizedBox(height: 2),
              Text(
                "AI를 사용해 이미지에서 주차 위치를 자동으로 인식합니다.",
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
