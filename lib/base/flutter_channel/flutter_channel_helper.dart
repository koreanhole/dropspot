import 'package:dropspot/base/drop_spot_router.dart';
import 'package:dropspot/base/flutter_channel/flutter_channel_input.dart';
import 'package:dropspot/base/flutter_channel/flutter_channel_input_actions.dart';
import 'package:dropspot/base/flutter_channel/flutter_channel_output.dart';
import 'package:dropspot/base/flutter_channel/flutter_channel_output_status.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class FlutterChannelHelper {
  static const MethodChannel _flutterChannel =
      MethodChannel("com.koreanhole.pluto.dropspot.flutterChannel");
  static const String _flutterMethod =
      "com.koreanhole.pluto.dropspot.methodName";

  void registerHandler() {
    _flutterChannel.setMethodCallHandler(
      (call) async {
        if (call.method == _flutterMethod) {
          // JSON 형식의 입력 데이터를 Map으로 받습니다.
          final Map<dynamic, dynamic>? rawInput = call.arguments as Map?;
          if (rawInput == null) {
            return FlutterChannelOutput(
              status: FlutterChannelOutputStatus.failure,
              message: "UnknownInput",
            ).toJson();
          }
          final FlutterChannelInput parsedInput =
              FlutterChannelInput.fromJson(rawInput);

          return _handleFlutterChannelInput(parsedInput).toJson();
        }
        throw PlatformException(
            code: 'Unimplemented', details: "해당 메서드가 구현되지 않았습니다.");
      },
    );
  }

  FlutterChannelOutput _handleFlutterChannelInput(FlutterChannelInput input) {
    Logger().d("FlutterChannel input: ${input.toJson()}");
    switch (input.action) {
      case FlutterChannelInputActions.deeplink:
        final Uri uri = Uri.parse(input.data);
        DropSpotRouter.routes.go('/${uri.host}');
        return FlutterChannelOutput(
          status: FlutterChannelOutputStatus.success,
          message: "routing success",
        );
      case FlutterChannelInputActions.unknown:
        final outputMessage = "Unknown FlutterChannelInputActions";
        return FlutterChannelOutput(
          status: FlutterChannelOutputStatus.failure,
          message: outputMessage,
        );
    }
  }
}
