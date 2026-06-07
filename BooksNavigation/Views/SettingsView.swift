//
//  SettingsView.swift
//  BooksNavigation
//
//  A two-column destination: it has no middle list, so it fills the space
//  beside the sidebar (see `NavigationItem.numberOfColumns`).
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showChapterNumbers") private var showChapterNumbers = true
    @AppStorage("preferLargeText") private var preferLargeText = false

    var body: some View {
        Form {
            Section("Display") {
                Toggle("Show chapter numbers", isOn: $showChapterNumbers)
                Toggle("Prefer large text", isOn: $preferLargeText)
            }

            Section {
                Text("Settings is a two-column screen — notice the middle list disappears when it is shown.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
    }
}
