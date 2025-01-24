import 'package:dropspot/base/data/public_parking_info.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
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
            SizedBox(height: 8),
            Icon(
              Icons.drag_handle_rounded,
              size: 32,
              color: darkGrey,
            ),
            SizedBox(height: 8),
            _PublicParkingLotInfoTitle(publicParkingInfo: publicParkingInfo),
            _PublicParkingLotInfoSubTitle(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 24),
            _PublicParkingLotFeeInfo(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 24),
            _PublicParkingLotTimeInfo(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 12),
            _PublicParkingLotDataInfo(publicParkingInfo: publicParkingInfo),
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
    return Text(
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      "${publicParkingInfo.parkingLotName} ${publicParkingInfo.parkingLotType} 주차장(${publicParkingInfo.parkingLotCategory})",
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
    return _PublicParkingInfoBackground(
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
            "결제방법",
          ),
          Text(
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
    return _PublicParkingInfoBackground(
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
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.close),
    );
  }
}

class _PublicParkingInfoBackground extends StatelessWidget {
  final Widget child;

  const _PublicParkingInfoBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: tertiaryColor,
          borderRadius: defaultBoxBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
