//
//  hipApp.swift
//  hip
//
//  Created by Mike Lucyšyn on 3/30/26.
//

import SwiftUI


@main
struct hipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .handlesExternalEvents(matching: [])

        WindowGroup(id: "hip-toolkit.preview", for: URL.self) { $url in
            PreviewWindowRootView(url: $url)
                .onOpenURL { url = $0 }
        }
        .defaultSize(width: 720, height: 520)
        .restorationBehavior(.disabled)
    }
}
