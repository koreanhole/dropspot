class PublicParkingInfo {
  final String parkingLotId; // 주차장관리번호
  final String parkingLotName; // 주차장명
  final String parkingLotType; // 주차장구분
  final String parkingLotCategory; // 주차장유형
  final String roadAddress; // 소재지도로명주소
  final String landAddress; // 소재지지번주소
  final String parkingSpaces; // 주차구획수
  final String zoneType; // 급지구분
  final String alternateDayRestriction; // 부제시행구분
  final String operatingDays; // 운영요일
  final String weekdayStartTime; // 평일운영시작시각
  final String weekdayEndTime; // 평일운영종료시각
  final String saturdayStartTime; // 토요일운영시작시각
  final String saturdayEndTime; // 토요일운영종료시각
  final String holidayStartTime; // 공휴일운영시작시각
  final String holidayEndTime; // 공휴일운영종료시각
  final String feeInfo; // 요금정보
  final String basicParkingTime; // 주차기본시간
  final String basicParkingFee; // 주차기본요금
  final String additionalTimeUnit; // 추가단위시간
  final String additionalFee; // 추가단위요금
  final String dailyPassTime; // 1일주차권요금적용시간
  final String dailyPassFee; // 1일주차권요금
  final String monthlyPassFee; // 월정기권요금
  final String paymentMethod; // 결제방법
  final String notes; // 특기사항
  final String managingAgency; // 관리기관명
  final String phoneNumber; // 전화번호
  final String latitude; // 위도
  final String longitude; // 경도
  final String hasDisabledParking; // 장애인전용주차구역보유여부
  final String dataReferenceDate; // 데이터기준일자
  final String providerCode; // 제공기관코드
  final String providerName; // 제공기관명

  PublicParkingInfo({
    required this.parkingLotId,
    required this.parkingLotName,
    required this.parkingLotType,
    required this.parkingLotCategory,
    required this.roadAddress,
    required this.landAddress,
    required this.parkingSpaces,
    required this.zoneType,
    required this.alternateDayRestriction,
    required this.operatingDays,
    required this.weekdayStartTime,
    required this.weekdayEndTime,
    required this.saturdayStartTime,
    required this.saturdayEndTime,
    required this.holidayStartTime,
    required this.holidayEndTime,
    required this.feeInfo,
    required this.basicParkingTime,
    required this.basicParkingFee,
    required this.additionalTimeUnit,
    required this.additionalFee,
    required this.dailyPassTime,
    required this.dailyPassFee,
    required this.monthlyPassFee,
    required this.paymentMethod,
    required this.notes,
    required this.managingAgency,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.hasDisabledParking,
    required this.dataReferenceDate,
    required this.providerCode,
    required this.providerName,
  });

  factory PublicParkingInfo.fromJson(Map<String, dynamic> json) {
    return PublicParkingInfo(
      parkingLotId: json['주차장관리번호'] ?? '',
      parkingLotName: json['주차장명'] ?? '',
      parkingLotType: json['주차장구분'] ?? '',
      parkingLotCategory: json['주차장유형'] ?? '',
      roadAddress: json['소재지도로명주소'] ?? '',
      landAddress: json['소재지지번주소'] ?? '',
      parkingSpaces: json['주차구획수'] ?? '',
      zoneType: json['급지구분'] ?? '',
      alternateDayRestriction: json['부제시행구분'] ?? '',
      operatingDays: json['운영요일'] ?? '',
      weekdayStartTime: json['평일운영시작시각'] ?? '',
      weekdayEndTime: json['평일운영종료시각'] ?? '',
      saturdayStartTime: json['토요일운영시작시각'] ?? '',
      saturdayEndTime: json['토요일운영종료시각'] ?? '',
      holidayStartTime: json['공휴일운영시작시각'] ?? '',
      holidayEndTime: json['공휴일운영종료시각'] ?? '',
      feeInfo: json['요금정보'] ?? '',
      basicParkingTime: json['주차기본시간'] ?? '',
      basicParkingFee: json['주차기본요금'] ?? '',
      additionalTimeUnit: json['추가단위시간'] ?? '',
      additionalFee: json['추가단위요금'] ?? '',
      dailyPassTime: json['1일주차권요금적용시간'] ?? '',
      dailyPassFee: json['1일주차권요금'] ?? '',
      monthlyPassFee: json['월정기권요금'] ?? '',
      paymentMethod: json['결제방법'] ?? '',
      notes: json['특기사항'] ?? '',
      managingAgency: json['관리기관명'] ?? '',
      phoneNumber: json['전화번호'] ?? '',
      latitude: json['위도'] ?? '',
      longitude: json['경도'] ?? '',
      hasDisabledParking: json['장애인전용주차구역보유여부'] ?? '',
      dataReferenceDate: json['데이터기준일자'] ?? '',
      providerCode: json['제공기관코드'] ?? '',
      providerName: json['제공기관명'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '주차장관리번호': parkingLotId,
      '주차장명': parkingLotName,
      '주차장구분': parkingLotType,
      '주차장유형': parkingLotCategory,
      '소재지도로명주소': roadAddress,
      '소재지지번주소': landAddress,
      '주차구획수': parkingSpaces,
      '급지구분': zoneType,
      '부제시행구분': alternateDayRestriction,
      '운영요일': operatingDays,
      '평일운영시작시각': weekdayStartTime,
      '평일운영종료시각': weekdayEndTime,
      '토요일운영시작시각': saturdayStartTime,
      '토요일운영종료시각': saturdayEndTime,
      '공휴일운영시작시각': holidayStartTime,
      '공휴일운영종료시각': holidayEndTime,
      '요금정보': feeInfo,
      '주차기본시간': basicParkingTime,
      '주차기본요금': basicParkingFee,
      '추가단위시간': additionalTimeUnit,
      '추가단위요금': additionalFee,
      '1일주차권요금적용시간': dailyPassTime,
      '1일주차권요금': dailyPassFee,
      '월정기권요금': monthlyPassFee,
      '결제방법': paymentMethod,
      '특기사항': notes,
      '관리기관명': managingAgency,
      '전화번호': phoneNumber,
      '위도': latitude,
      '경도': longitude,
      '장애인전용주차구역보유여부': hasDisabledParking,
      '데이터기준일자': dataReferenceDate,
      '제공기관코드': providerCode,
      '제공기관명': providerName,
    };
  }
}
