import WidgetKit
import SwiftUI

// 1. TimelineEntry 정의: 위젯에 표시할 데이터를 담은 구조체
struct LockScreenEntry: TimelineEntry {
    let date: Date
    let parkedLevel: Int
    // 추가 데이터(예: 텍스트, 이미지 등)를 필요에 따라 선언
}

// 2. TimelineProvider 구현: 위젯에 제공할 타임라인(데이터 업데이트)을 관리
struct Provider: TimelineProvider {
    // 플레이스홀더(미리보기 등에서 사용)
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(date: Date(), parkedLevel: 1)
    }
    
    // 스냅샷: 위젯 갤러리 등 빠른 미리보기를 위해 사용
    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let prefs = UserDefaults(suiteName: "group.com.koreanhole.pluto.dropspot.widget")
        let parkedLevelFromPreference = prefs?.integer(forKey: "parkedLevel")
        if (parkedLevelFromPreference != nil) {
            let entry = LockScreenEntry(date: Date(), parkedLevel: parkedLevelFromPreference ?? -999)
            completion(entry)
        } else {
            let entry = LockScreenEntry(date: Date(), parkedLevel: -999)
            completion(entry)
        }

    }
    
    // 실제 타임라인 구성: 일정 시간마다 업데이트할 데이터를 제공
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        getSnapshot(in: context) { (entry) in
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
    }
}

// 3. 위젯 뷰 작성: 실제 위젯 UI를 SwiftUI로 구현
struct LockScreenWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        entry.parkedLevel.description
            .appropriateImage()
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 80, maxHeight: 80)
            .clipped()
            .widgetURL(URL(string: "dropspot://home_screen"))
            .widgetBackground()
    }
}

extension View {
    func widgetBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
            }
        } else {
            return background()
        }
    }
}

extension String {
    func appropriateImage() -> Image {
        if (self == "-999") {
            Image("lockscreen_widget_app_icon")
        } else {
            Image(self)
        }
    }
}

// 4. 위젯 기본 구조 설정 및 잠금화면 위젯 지원 설정
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("주차 위치 확인")
        .description("현재 주차된 차량의 위치를 확인합니다.")
        .supportedFamilies([.accessoryCircular])
    }
}
