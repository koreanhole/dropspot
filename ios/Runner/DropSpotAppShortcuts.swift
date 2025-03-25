//
//  DropSpotAppShortcuts.swift
//  Runner
//
//  Created by 순형 on 3/25/25.
//

// An AppShortcut turns an Intent into a full fledged shortcut
// AppShortcuts are returned from a struct that implements the AppShortcuts
// protocol

import AppIntents

@available(iOS 18.0, *)
struct DropSpotAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddParkingSpotWithPhotoIntent(),
            phrases: ["\(.applicationName) 위치 추가"],
            shortTitle: "주차 위치 추가",
            systemImageName: "photo.badge.plus.fill"
        )
    }
}
