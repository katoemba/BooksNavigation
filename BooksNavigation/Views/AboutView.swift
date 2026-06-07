//
//  AboutView.swift
//  BooksNavigation
//
//  The other two-column destination.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text("BooksNavigation")
                .font(.largeTitle.bold())
            Text("A minimal sample showing a NavigationRouter driving a NavigationSplitView with both two- and three-column layouts.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 420)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("About")
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
