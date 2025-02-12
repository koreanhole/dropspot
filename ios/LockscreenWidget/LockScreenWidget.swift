import WidgetKit
import SwiftUI

// 1. TimelineEntry 정의: 위젯에 표시할 데이터를 담은 구조체
struct LockScreenEntry: TimelineEntry {
    let date: Date
    // 추가 데이터(예: 텍스트, 이미지 등)를 필요에 따라 선언
}

// 2. TimelineProvider 구현: 위젯에 제공할 타임라인(데이터 업데이트)을 관리
struct Provider: TimelineProvider {
    // 플레이스홀더(미리보기 등에서 사용)
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(date: Date())
    }
    
    // 스냅샷: 위젯 갤러리 등 빠른 미리보기를 위해 사용
    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let entry = LockScreenEntry(date: Date())
        completion(entry)
    }
    
    // 실제 타임라인 구성: 일정 시간마다 업데이트할 데이터를 제공
    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let currentDate = Date()
        // 예시: 단일 엔트리, 업데이트 정책은 필요에 따라 설정 (여기선 갱신 안 함)
        let entry = LockScreenEntry(date: currentDate)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// 3. 위젯 뷰 작성: 실제 위젯 UI를 SwiftUI로 구현
struct LockScreenWidgetEntryView: View {
    var entry: LockScreenEntry

    var body: some View {
        // 예시: 현재 시간을 텍스트로 표시
        Text(entry.date, style: .time)
            .font(.headline)
            .padding()
    }
}

// 4. 위젯 기본 구조 설정 및 잠금화면 위젯 지원 설정
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("잠금화면 위젯")
        .description("iOS 잠금화면에 현재 시간을 표시합니다.")
        // iOS 16 잠금화면 위젯은 아래 세 가지 패밀리 사용 가능 (.accessoryCircular, .accessoryRectangular, .accessoryInline)
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
