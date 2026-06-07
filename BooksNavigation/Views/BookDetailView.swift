//
//  BookDetailView.swift
//  BooksNavigation
//
//  Detail column. Demonstrates pushing further: the author button pushes the
//  author onto the detail stack, letting you walk book → author → book → …
//

import SwiftUI

struct BookDetailView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library
    let book: Book

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.largeTitle.bold())
                    if let author = library.author(for: book) {
                        Button {
                            router.push(.author(author))
                        } label: {
                            Label(author.name, systemImage: "person")
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.tint)
                    }
                    Text(verbatim: "Published \(book.year)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Synopsis") {
                Text(book.synopsis)
            }

            Section("Chapters") {
                ForEach(book.chapters) { chapter in
                    HStack {
                        Text(verbatim: "\(chapter.number).")
                            .foregroundStyle(.secondary)
                            .frame(width: 28, alignment: .leading)
                        Text(chapter.title)
                    }
                }
            }
        }
        .navigationTitle(book.title)
    }
}
