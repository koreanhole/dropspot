////
////  AppShortcuts.swift
////  Runner
////
////  Created by 순형 on 3/18/25.
////

import AppIntents

struct MyAppShortcutIntent: AppIntent {
    // 단축어 앱에서 표시될 제목
    static var title: LocalizedStringResource = "사진으로 주차 위치 추가"
    
    // 단축어에 대한 설명 및 카테고리 지정
    static var description = IntentDescription(
        "사진을 찍어 주차 위치를 추가합니다.",
        categoryName: "주차 위치 추가"
    )
    
    // 단축어 실행 시 호출되는 비동기 함수
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
