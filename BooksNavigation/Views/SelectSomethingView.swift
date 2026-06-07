//
//  SelectSomethingView.swift
//  BooksNavigation
//
//  Placeholder shown in the empty detail column before a selection is made.
//

import SwiftUI

struct SelectSomethingView: View {
    let label: String
    let systemImage: String

    var body: some View {
        ContentUnavailableView(label, systemImage: systemImage)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SelectSomethingView(label: "Select an Author", systemImage: "person")
}
