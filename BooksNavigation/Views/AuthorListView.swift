//
//  AuthorListView.swift
//  BooksNavigation
//
//  Middle column. Selecting an author replaces the detail column's root.
//

import SwiftUI

struct AuthorListView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library

    var body: some View {
        List {
            ForEach(library.authors) { author in
                SelectionRow {
                    router.setDetailRoot(.author(author))
                } content: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(author.name)
                            .font(.headline)
                        Text("\(library.books(by: author).count) books")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Authors")
    }
}

#Preview {
    NavigationStack {
        AuthorListView()
    }
    .environment(Library())
    .environment(NavigationRouter())
}
