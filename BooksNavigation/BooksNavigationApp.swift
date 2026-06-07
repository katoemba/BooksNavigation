//
//  BooksNavigationApp.swift
//  BooksNavigation
//
//  Creates the shared Library and NavigationRouter and injects them into the
//  environment. The whole UI is hosted by RegularContentView.
//

import SwiftUI

@main
struct BooksNavigationApp: App {
    @State private var library = Library()
    @State private var router = NavigationRouter()

    var body: some Scene {
        WindowGroup {
            RegularContentView()
                .environment(library)
                .environment(router)
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 720)
        #endif
    }
}
