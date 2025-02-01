class ParkingInfo {
  final int? parkedLevel;
  final DateTime? parkedDateTime;

  ParkingInfo({
    required this.parkedLevel,
    required this.parkedDateTime,
  });

  // 객체를 Map으로 변환 (JSON 직렬화를 위해)
  Map<String, dynamic> toJson() {
    return {
      'parkedLevel': parkedLevel,
      'parkedDateTime': parkedDateTime?.toIso8601String(),
    };
  }

  // JSON(Map)으로부터 객체를 생성 (역직렬화)
  factory ParkingInfo.fromJson(Map<String, dynamic> json) {
    return ParkingInfo(
      parkedLevel: json['parkedLevel'] as int?,
      parkedDateTime: json['parkedDateTime'] != null
          ? DateTime.parse(json['parkedDateTime'] as String)
          : null,
    );
  }
}
