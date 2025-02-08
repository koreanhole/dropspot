import 'package:dropspot/base/data/public_parking_info.dart';
import 'package:dropspot/base/theme/colors.dart';
import 'package:dropspot/base/theme/radius.dart';
import 'package:dropspot/components/info_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OpenInMapsModalSheet extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  const OpenInMapsModalSheet({super.key, required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            _OpenInMapsInfoCards(publicParkingInfo: publicParkingInfo),
            SizedBox(height: 24),
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
      ),
    );
  }
}

class _OpenInMapsInfoCards extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;

  const _OpenInMapsInfoCards({required this.publicParkingInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OpenInMapsLabel(
          publicParkingInfo: publicParkingInfo,
          labelText: "카카오맵에서 열기",
          iconPath: "assets/icons/kakaomap_icon.png",
          onClick: () async {
            final url =
                "kakaomap://look?p=${publicParkingInfo.latitude},${publicParkingInfo.longitude}";
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            }
          },
        ),
        SizedBox(height: 12),
        _OpenInMapsLabel(
          publicParkingInfo: publicParkingInfo,
          labelText: "네이버지도에서 열기",
          iconPath: "assets/icons/navermap_icon.png",
          onClick: () async {
            final url =
                "nmap://place?name=${publicParkingInfo.parkingLotName}&lat=${publicParkingInfo.latitude}&lng=${publicParkingInfo.longitude}";
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            }
          },
        ),
        SizedBox(height: 12),
        _OpenInMapsLabel(
          publicParkingInfo: publicParkingInfo,
          labelText: "티맵에서 열기",
          iconPath: "assets/icons/tmap_icon.png",
          onClick: () async {
            final url =
                "tmap://search?name=${publicParkingInfo.parkingLotName}&x=${publicParkingInfo.longitude}&y=${publicParkingInfo.latitude}";
            if (await canLaunchUrlString(url)) {
              await launchUrlString(url);
            }
          },
        )
      ],
    );
  }
}

class _OpenInMapsLabel extends StatelessWidget {
  final PublicParkingInfo publicParkingInfo;
  final String labelText;
  final String iconPath;
  final VoidCallback onClick;

  const _OpenInMapsLabel(
      {required this.publicParkingInfo,
      required this.labelText,
      required this.iconPath,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: defaultBoxBorderRadius / 2,
                    image: DecorationImage(
                      image: AssetImage(iconPath),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.open_in_new_outlined),
          ],
        ),
      ),
    );
  }
}
