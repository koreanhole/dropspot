////
////  AppShortcuts.swift
////  Runner
////
////  Created by 순형 on 3/18/25.
////

import AppIntents
import SwiftUICore

@available(iOS 18.0, *)
struct AddParkingSpotWithPhotoIntent: AppIntent {
    // 단축어 앱에서 표시될 제목
    static var title: LocalizedStringResource = "주차 위치 추가"
    static var isDiscoverable: Bool = true
    static var openAppWhenRun: Bool = true
    
    // 단축어에 대한 설명 및 카테고리 지정
    static var description = IntentDescription(
        "주차 위치를 추가합니다.",
        categoryName: "주차 위치 추가"
    )
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        let url = URL(string: "dropspot://home_screen")!
        EnvironmentValues().openURL(url)
        return .result(opensIntent: OpenURLIntent(url))
    }
}
