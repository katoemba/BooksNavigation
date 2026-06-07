//
//  SearchView.swift
//  BooksNavigation
//
//  Middle column. Live-filters books; a result replaces the detail root.
//

import SwiftUI

struct SearchView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library
    @State private var query = ""

    private var results: [Book] {
        library.searchBooks(query)
    }

    var body: some View {
        List {
            if query.isEmpty {
                ContentUnavailableView(
                    "Search Books",
                    systemImage: "magnifyingglass",
                    description: Text("Type a title or author name.")
                )
            } else if results.isEmpty {
                ContentUnavailableView.search(text: query)
            } else {
                ForEach(results) { book in
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
        }
        .searchable(text: $query, placement: .toolbar, prompt: "Title or author")
        .navigationTitle("Search")
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(Library())
    .environment(NavigationRouter())
}
