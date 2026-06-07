//
//  BookListView.swift
//  BooksNavigation
//
//  Middle column. Selecting a book replaces the detail column's root.
//

import SwiftUI

struct BookListView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library

    var body: some View {
        List {
            ForEach(library.books) { book in
                SelectionRow {
                    router.setDetailRoot(.book(book))
                } content: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title)
                            .font(.headline)
                        Text(library.author(for: book)?.name ?? "Unknown author")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Books")
    }
}
