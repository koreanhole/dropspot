import 'package:dropspot/base/data/public_parking_info.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

final titleTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w300,
);
final infoSpacing = SizedBox(height: 12);
final labelTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

class PublicParkingLotInfoModalSheet extends StatelessWidget {
  final NMarker mapMarker;
  final PublicParkingInfo publicParkingInfo;

  const PublicParkingLotInfoModalSheet({
    super.key,
    required this.mapMarker,
    required this.publicParkingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            _PublicParkingLotInfoTitle(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 4),
            _PublicParkingLotInfoSubTitle(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 24),
            _PublicParkingLotFeeInfo(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 24),
            _PublicParkingLotTimeInfo(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 12),
            _PublicParkingLotDataInfo(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 12),
            _PublicParkingLotInfoActionButton(
                publicParkingInfo: publicParkingInfo),
          ],
        ),
      ),
    );
  }
}

class _PublicParkingLotInfoTitle extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotInfoTitle({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
        "${publicParkingInfo.parkingLotName} ${publicParkingInfo.parkingLotType} 주차장(${publicParkingInfo.parkingLotCategory})",
      ),
    );
  }
}

class _PublicParkingLotInfoSubTitle extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotInfoSubTitle({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return Text(
        style: TextStyle(
          fontSize: 16,
        ),
        "🚗${publicParkingInfo.parkingSpaces}자리");
  }
}

class _PublicParkingLotFeeInfo extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotFeeInfo({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            style: titleTextStyle,
            "기본요금",
          ),
          Text(
            style: labelTextStyle,
            "${publicParkingInfo.basicParkingFee}원(${publicParkingInfo.basicParkingTime}분)",
          ),
          infoSpacing,
          Text(
            style: titleTextStyle,
            "추가요금",
          ),
          Text(
            style: labelTextStyle,
            "${publicParkingInfo.additionalFee}원(${publicParkingInfo.additionalTime}분)",
          ),
          infoSpacing,
          Text(
            style: titleTextStyle,
            "결제정보",
          ),
          publicParkingInfo.feeInfo == "무료"
              ? Text(style: labelTextStyle, publicParkingInfo.feeInfo)
              : Text(
                  style: labelTextStyle,
                  publicParkingInfo.paymentMethod,
                ),
        ],
      ),
    );
  }
}

class _PublicParkingLotTimeInfo extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotTimeInfo({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            style: titleTextStyle,
            "운영요일",
          ),
          Text(
            style: labelTextStyle,
            publicParkingInfo.operatingDays,
          ),
          infoSpacing,
          Text(
            style: titleTextStyle,
            "평일 운영시간",
          ),
          Text(
            style: labelTextStyle,
            "${publicParkingInfo.weekdayStartTime} ~ ${publicParkingInfo.weekdayEndTime}",
          ),
          infoSpacing,
          Text(
            style: titleTextStyle,
            "토요일 운영시간",
          ),
          Text(
            style: labelTextStyle,
            "${publicParkingInfo.saturdayStartTime} ~ ${publicParkingInfo.saturdayEndTime}",
          ),
          infoSpacing,
          Text(
            style: titleTextStyle,
            "일요일 운영시간",
          ),
          Text(
            style: labelTextStyle,
            "${publicParkingInfo.holidayStartTime} ~ ${publicParkingInfo.holidayEndTime}",
          ),
        ],
      ),
    );
  }
}

class _PublicParkingLotDataInfo extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotDataInfo({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    final dataInfoTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.w300,
    );
    return Text(
      style: dataInfoTextStyle,
      "기준일자: ${publicParkingInfo.dataReferenceDate} / 제공기관: ${publicParkingInfo.providerName}",
    );
  }
}

class _PublicParkingLotInfoActionButton extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const _PublicParkingLotInfoActionButton({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PublicParkingInfoActionButton(
          label: "닫기",
          onPressed: () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 12),
        _PublicParkingInfoActionButton(
          label: "지도앱에서 보기",
          onPressed: () {},
        ),
      ],
    );
  }
}

class _PublicParkingInfoActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PublicParkingInfoActionButton(
      {required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(tertiaryColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: defaultBoxBorderRadius),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
