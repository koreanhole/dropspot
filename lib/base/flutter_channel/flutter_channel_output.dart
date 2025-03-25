import 'package:dropspot/base/flutter_channel/flutter_channel_output_status.dart';

class FlutterChannelOutput {
  final FlutterChannelOutputStatus status;
  final String message;
  final String timestamp;

  FlutterChannelOutput({
    required this.status,
    required this.message,
    String? timestamp,
  }) : timestamp = timestamp ?? getDefaultTimestamp();

  // timestamp의 기본값을 생성하는 메서드 (예: 현재 시간을 ISO 8601 문자열로 반환)
  static String getDefaultTimestamp() {
    return DateTime.now().toIso8601String();
  }

  // JSON 데이터를 기반으로 FlutterChannelOutput 인스턴스를 생성하는 factory 생성자
  factory FlutterChannelOutput.fromJson(Map<String, dynamic> json) {
    final statusString = json['status'] as String? ?? "unknown";
    final FlutterChannelOutputStatus flutterChannelOutputStatus =
        FlutterChannelOutputStatusStatusExtension.fromString(statusString);
    return FlutterChannelOutput(
      status: flutterChannelOutputStatus,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  // Person 인스턴스를 JSON으로 변환하는 메서드 (필요한 경우)
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
