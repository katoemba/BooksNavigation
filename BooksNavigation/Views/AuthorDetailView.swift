//
//  AuthorDetailView.swift
//  BooksNavigation
//
//  Detail column. Tapping one of the author's books *pushes* onto the detail
//  stack (rather than replacing the root), so the back button returns here.
//

import SwiftUI

struct AuthorDetailView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library
    let author: Author

    var body: some View {
        List {
            Section {
                Text(author.bio)
                    .font(.body)
            }

            Section("Books") {
                ForEach(library.books(by: author)) { book in
                    SelectionRow {
                        router.push(.bookByAuthor(book, author))
                    } content: {
                        HStack {
                            Text(book.title)
                            Spacer()
                            Text(verbatim: "\(book.year)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(author.name)
    }
}

#Preview {
    let library = Library()
    NavigationStack {
        AuthorDetailView(author: library.authors[0])
    }
    .environment(library)
    .environment(NavigationRouter())
}
