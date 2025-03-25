import 'package:dropspot/base/flutter_channel/flutter_channel_input_actions.dart';

class FlutterChannelInput {
  final FlutterChannelInputActions action;
  final String data;

  FlutterChannelInput({
    required this.action,
    required this.data,
  });

  // JSON 데이터를 기반으로 FlutterChannelInput 인스턴스를 생성하는 factory 생성자
  factory FlutterChannelInput.fromJson(Map<dynamic, dynamic> json) {
    final actionString = json['action'] as String? ?? "unknown";
    final FlutterChannelInputActions flutterChannelInputActions =
        FlutterChannelInputActionsStatusStatusExtension.fromString(
            actionString);
    return FlutterChannelInput(
      action: flutterChannelInputActions,
      data: json['data'] as String,
    );
  }

  // Person 인스턴스를 JSON으로 변환하는 메서드 (필요한 경우)
  Map<String, dynamic> toJson() {
    return {
      'action': action.name,
      'data': data,
    };
  }
}
