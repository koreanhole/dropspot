enum FlutterChannelInputActions {
  deeplink,
  unknown;
}

extension FlutterChannelInputActionsStatusStatusExtension
    on FlutterChannelInputActions {
  // enum 값을 문자열로 변환 (toJson 등에 사용)
  String get value {
    switch (this) {
      case FlutterChannelInputActions.deeplink:
        return FlutterChannelInputActions.deeplink.name;
      case FlutterChannelInputActions.unknown:
        return FlutterChannelInputActions.unknown.name;
    }
  }

  // 문자열을 enum 값으로 변환 (fromJson 등에 사용)
  static FlutterChannelInputActions fromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case "deeplink":
        return FlutterChannelInputActions.deeplink;
      default:
        return FlutterChannelInputActions.unknown;
    }
  }
}
