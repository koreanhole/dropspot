# Dropspot Project Architecture & Guide

## 🎯 핵심 목표 (Core Objectives)
Dropspot(드롭스팟)은 사용자가 주차한 차량의 위치를 쉽고 빠르게 기록하고 확인할 수 있도록 돕는 모바일 애플리케이션입니다. 사진 한 장으로 주차 구역과 시간을 기억하게 해줍니다.
- **주요 기능**: 카메라를 활용한 주차 기둥 텍스트 인식(OCR), 수동 주차 위치 등록, iOS 홈/잠금 화면 위젯 연동 및 스마트워치(Wear OS) 연동.

## 🏗 전체적인 소프트웨어 아키텍처 (Software Architecture)
- **프레임워크**: Flutter (Dart) 기반 크로스 플랫폼 애플리케이션.
- **의존성 주입 및 상태 관리**: `provider` (`ChangeNotifierProvider`)를 통한 전역 상태 관리.
- **라우팅**: `go_router`를 이용한 ShellRoute 기반의 바텀 네비게이션 구조 및 `app_links`를 통한 딥링크(App Link) 지원.
- **데이터 영속성**: `shared_preferences`를 사용한 간단한 상태 저장과 `path_provider`를 활용한 로컬 파일 시스템 기반 메인 주차 이미지 캐싱.
- **주요 외부 모듈**:
  - `google_mlkit_text_recognition`: 주차 층수 인식을 위한 기기 자체 온디바이스 OCR.
  - `exif`: 주차 사진에서 촬영 일시(Image DateTime) 정보 추출.
  - `home_widget`: iOS 잠금 화면/홈 화면 위젯 등으로 주차 위치 데이터(App Group 연동) 전송.
  - `flutter_naver_map` 및 기타 지도/위치 의존성 포함 중.

## 💼 주요 비즈니스 로직 (Business Logic)
핵심 비즈니스 로직은 `lib/providers/parking_info_provider.dart`에 집약되어 있습니다.

1. **이미지 기반 자동 파킹 위치 등록 (`setParkingImageInfo`)**:
   - 촬영된 이미지를 디바이스 도큐먼트 디렉토리에 복사/저장.
   - ML Kit TextRecognizer를 사용하여 텍스트 추출 후, 정규식(`RegExp(r'b\s*(\d+)', caseSensitive: false)`)을 통해 지하 주차장의 층수 추출.
   - 이미지의 Exif 정보를 읽어 촬영 시각을 분석하여 주차 시간으로 활용.
   - 업데이트된 앱 그룹 데이터를 OS 위젯단과 동기화.

2. **수동 주차 위치 등록 (`setParkingManualInfo`)**:
   - 자동 인식이 실패하거나 사용자가 직접 층수를 선택하는 경우, 에셋 이미지를 활용해 주차 상태를 생성하고 `SharedPreferences`에 정보를 영구 저장.

3. **기기 용량 효율화 (로컬 캐시 관리)**:
   - 새로운 주차 위치가 갱신될 때마다 기존의 불필요한 주차 이미지 파일들을 안전하게 파기하여 저장 공간 낭비를 방지 (`_deleteAllParkingImage`).

## 📁 코드 구성 (Code Structure)
앱의 소스 코드는 역할과 책임을 기반으로 `lib/` 에 깔끔하게 분리되어 있습니다.

```text
lib/
├── main.dart                             # 앱 진입점, Provider, Router, 로깅 설정 등 전역 초기화
├── base/                                 # 공통 모듈 및 Data Layer
│   ├── data/                             # 모델 클래스 (e.g., parking_info.dart)
│   ├── theme/                            # 컬러 팔레트 등 앱 룩앤필 토큰
│   └── drop_spot_router.dart             # 라우트 설계 및 GoRouter 구성 정의
├── components/                           # 재사용 가능한 UI 위젯 모음
│   ├── image_viewer.dart                 # 주차 사진 표출 뷰어
│   ├── info_card.dart                    # 주차 위치/시간 요약 카드 위젯
│   └── ... 
├── providers/                            # 상태 및 도메인 로직 Layer
│   └── parking_info_provider.dart        # 메인 주차 정보를 관리, 처리, 지속하는 핵심 파일
└── screens/                              # 개별 Presentation 화면(Page) 모음
    ├── home_screen.dart                  # 초기 화면, 정보 표출 및 SpeedDial (작업 액션) 탑재
    ├── camera_screen.dart                # 직접 사진을 촬영하여 등록하기 위한 화면
    ├── manual_add_parking_screen.dart    # 슬라이더, 버튼 등을 통해 수동으로 층수를 세팅하는 화면
    └── more_screen.dart                  # 앱 내 부가 정보, 설정 화면
```

## 🛠 개발 환경 (Development Environment)
- **버전 관리**: `fvm` (Flutter Version Management)을 사용하여 Flutter SDK 버전을 관리합니다.
- **명령 규칙**: 모든 Flutter 관련 명령은 반드시 `fvm` prefix를 사용해야 합니다. (예: `fvm flutter run`, `fvm flutter pub get`)
