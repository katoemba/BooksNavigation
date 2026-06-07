//
//  SelectionRow.swift
//  BooksNavigation
//
//  A list row that triggers a router action instead of a plain NavigationLink.
//  Using the router (rather than `NavigationLink(value:)`) is what keeps the
//  detail column under the router's control across both layouts.
//

import SwiftUI

struct SelectionRow<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Button(action: action) {
            HStack {
                content()
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        SelectionRow(action: {}) {
            Label("Sample row", systemImage: "book")
        }
    }
}
