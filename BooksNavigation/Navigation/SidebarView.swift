//
//  SidebarView.swift
//  BooksNavigation
//
//  The first column. A selection-driven List whose chosen value is handed to
//  the router via `setContentRoot`. On appear it reads `derivedMenuItem` so the
//  correct row is highlighted after a state restore or programmatic change.
//

import SwiftUI

struct SidebarView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var selection: NavigationItem?

    var body: some View {
        List(selection: $selection) {
            Section("Browse") {
                ForEach(NavigationItem.browseCases) { item in
                    Label(item.displayName, systemImage: item.iconName)
                        .tag(item)
                }
            }

            Section("More") {
                ForEach(NavigationItem.otherCases) { item in
                    Label(item.displayName, systemImage: item.iconName)
                        .tag(item)
                }
            }
        }
        .navigationTitle("Books")
        .onAppear {
            selection = router.derivedMenuItem
        }
        .onChange(of: selection) { _, newValue in
            if let newValue {
                router.setContentRoot(newValue)
            }
        }
    }
}
