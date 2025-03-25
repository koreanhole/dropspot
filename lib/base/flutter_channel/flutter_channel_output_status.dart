enum FlutterChannelOutputStatus {
  success,
  failure,
  unknown;
}

extension FlutterChannelOutputStatusStatusExtension
    on FlutterChannelOutputStatus {
  // enum 값을 문자열로 변환 (toJson 등에 사용)
  String get value {
    switch (this) {
      case FlutterChannelOutputStatus.success:
        return FlutterChannelOutputStatus.success.name;
      case FlutterChannelOutputStatus.failure:
        return FlutterChannelOutputStatus.failure.name;
      case FlutterChannelOutputStatus.unknown:
        return FlutterChannelOutputStatus.unknown.name;
    }
  }

  // 문자열을 enum 값으로 변환 (fromJson 등에 사용)
  static FlutterChannelOutputStatus fromString(String statusString) {
    switch (statusString.toLowerCase()) {
      case "success":
        return FlutterChannelOutputStatus.success;
      case "failure":
        return FlutterChannelOutputStatus.failure;
      default:
        return FlutterChannelOutputStatus.unknown;
    }
  }
}
