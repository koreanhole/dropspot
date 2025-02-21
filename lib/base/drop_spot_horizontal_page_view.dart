import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DropSpotHorizontalPageView extends StatefulWidget {
  final List<Widget> pages;
  const DropSpotHorizontalPageView({
    super.key,
    required this.pages,
  });

  @override
  State<DropSpotHorizontalPageView> createState() =>
      _DropSpotHorizontalPageViewState();
}

class _DropSpotHorizontalPageViewState
    extends State<DropSpotHorizontalPageView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // PageView를 Expanded로 감싸서 화면을 꽉 채우도록 합니다.
          Expanded(
            child: PageView(
              controller: _pageController,
              children: widget.pages,
            ),
          ),
          // 페이지 도트 표시 영역
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _pageController, // PageController 연결
              count: widget.pages.length, // 페이지 수
              effect: WormEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(tertiaryColor),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: defaultBoxBorderRadius),
              ),
            ),
            child: Text(
              "닫기",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
