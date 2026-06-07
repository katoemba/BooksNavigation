//
//  ReadingListDetailView.swift
//  BooksNavigation
//
//  Detail column. Tapping a book pushes it onto the detail stack.
//

import SwiftUI

struct ReadingListDetailView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library
    let list: ReadingList

    var body: some View {
        List {
            ForEach(library.books(in: list)) { book in
                SelectionRow {
                    router.push(.book(book))
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
        .navigationTitle(list.name)
    }
}
