//
//  Library.swift
//  BooksNavigation
//
//  A tiny in-memory data store. The navigation pattern is the point of this
//  sample, so the data layer is deliberately trivial: plain value types and a
//  handful of hardcoded records.
//

import Foundation
import Observation

struct Author: Identifiable, Hashable {
    let id: UUID
    let name: String
    let bio: String
}

struct Book: Identifiable, Hashable {
    let id: UUID
    let title: String
    let authorID: UUID
    let year: Int
    let synopsis: String
    let chapters: [Chapter]
}

struct Chapter: Identifiable, Hashable {
    let id: UUID
    let number: Int
    let title: String
}

struct ReadingList: Identifiable, Hashable {
    let id: UUID
    let name: String
    let bookIDs: [UUID]
}

/// The single source of truth for sample content, injected into the
/// environment by the app and read by the leaf views.
@Observable
@MainActor
final class Library {
    private(set) var authors: [Author] = []
    private(set) var books: [Book] = []
    private(set) var readingLists: [ReadingList] = []

    init() {
        buildSampleData()
    }

    // MARK: - Lookups

    func author(for book: Book) -> Author? {
        authors.first { $0.id == book.authorID }
    }

    func books(by author: Author) -> [Book] {
        books
            .filter { $0.authorID == author.id }
            .sorted { $0.year < $1.year }
    }

    func books(in list: ReadingList) -> [Book] {
        list.bookIDs.compactMap { id in books.first { $0.id == id } }
    }

    /// Naive case-insensitive search across book titles and author names.
    func searchBooks(_ query: String) -> [Book] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return [] }
        return books.filter { book in
            book.title.localizedCaseInsensitiveContains(trimmed)
                || (author(for: book)?.name.localizedCaseInsensitiveContains(trimmed) ?? false)
        }
    }

    // MARK: - Sample data

    private func buildSampleData() {
        func chapters(_ titles: [String]) -> [Chapter] {
            titles.enumerated().map { index, title in
                Chapter(id: UUID(), number: index + 1, title: title)
            }
        }

        let leguin = Author(
            id: UUID(),
            name: "Ursula K. Le Guin",
            bio: "American author known for works of speculative fiction, including the Earthsea fantasy series and the Hainish science-fiction cycle."
        )
        let butler = Author(
            id: UUID(),
            name: "Octavia E. Butler",
            bio: "Multiple Hugo and Nebula award winner, and the first science-fiction writer to receive a MacArthur Fellowship."
        )
        let borges = Author(
            id: UUID(),
            name: "Jorge Luis Borges",
            bio: "Argentine short-story writer, essayist and poet, a central figure of Spanish-language and international literature."
        )

        authors = [leguin, butler, borges]

        books = [
            Book(
                id: UUID(),
                title: "A Wizard of Earthsea",
                authorID: leguin.id,
                year: 1968,
                synopsis: "A young mage named Ged grows into his power and confronts the shadow he unleashes.",
                chapters: chapters(["Warriors in the Mist", "The Shadow", "The School for Wizards", "The Loosing of the Shadow"])
            ),
            Book(
                id: UUID(),
                title: "The Left Hand of Darkness",
                authorID: leguin.id,
                year: 1969,
                synopsis: "An envoy to a planet of ambisexual beings learns the cost and meaning of trust.",
                chapters: chapters(["A Parade in Erhenrang", "The Place Inside the Blizzard", "The Question of Sex"])
            ),
            Book(
                id: UUID(),
                title: "Kindred",
                authorID: butler.id,
                year: 1979,
                synopsis: "A modern Black woman is pulled back in time to a pre-Civil War plantation.",
                chapters: chapters(["The River", "The Fire", "The Fall", "The Fight", "The Storm"])
            ),
            Book(
                id: UUID(),
                title: "Parable of the Sower",
                authorID: butler.id,
                year: 1993,
                synopsis: "In a collapsing near-future America, a young woman founds a new belief system.",
                chapters: chapters(["2024", "2025", "2026", "2027"])
            ),
            Book(
                id: UUID(),
                title: "Ficciones",
                authorID: borges.id,
                year: 1944,
                synopsis: "A landmark collection of labyrinthine short stories about infinity, mirrors and time.",
                chapters: chapters(["The Garden of Forking Paths", "The Library of Babel", "Funes the Memorious"])
            ),
        ]

        readingLists = [
            ReadingList(
                id: UUID(),
                name: "Speculative Classics",
                bookIDs: [books[0].id, books[1].id, books[4].id]
            ),
            ReadingList(
                id: UUID(),
                name: "Octavia Butler",
                bookIDs: [books[2].id, books[3].id]
            ),
        ]
    }
}
