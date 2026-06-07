//
//  NavigationRouter.swift
//  BooksNavigation
//
//  The router owns all navigation *state* and exposes *intent* methods
//  (`setContentRoot`, `setDetailRoot`, `push`). Views never mutate a
//  NavigationStack path directly — they call the router, which keeps the two
//  and three column layouts behaving consistently.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class NavigationRouter {
    /// What the middle column shows (a list). Ignored in two-column layouts.
    var contentRoot: NavigationItem = .authors

    /// The root of the detail column.
    var detailRoot: NavigationItem = .selectSomething(label: "Select an Author", systemImage: "person")

    /// The push/pop stack layered on top of `detailRoot` in the detail column.
    var detailStack: [NavigationItem] = []

    // MARK: - Intent

    /// Called when the user picks an item in the sidebar. Establishes the
    /// middle column and resets the detail column to an appropriate root.
    func setContentRoot(_ item: NavigationItem) {
        detailStack = []

        switch item {
        case .authors:
            contentRoot = .authors
            detailRoot = .selectSomething(label: "Select an Author", systemImage: "person")
        case .books:
            contentRoot = .books
            detailRoot = .selectSomething(label: "Select a Book", systemImage: "book")
        case .readingLists:
            contentRoot = .readingLists
            detailRoot = .selectSomething(label: "Select a Reading List", systemImage: "list.bullet.rectangle")
        case .search:
            contentRoot = .search
            detailRoot = .selectSomething(label: "Search for a Book", systemImage: "magnifyingglass")

        // Two-column destinations have no middle list; they fill the detail.
        case .settings:
            detailRoot = .settings
        case .about:
            detailRoot = .about

        default:
            contentRoot = item
        }
    }

    /// Replace the detail column's root (used when selecting a row in the
    /// middle column). Clears any pushed stack.
    func setDetailRoot(_ item: NavigationItem) {
        detailStack = []
        detailRoot = item
    }

    /// Push a new screen onto the detail column's stack.
    func push(_ item: NavigationItem) {
        detailStack.append(item)
    }

    // MARK: - Sidebar selection

    /// Maps the current navigation state back to the sidebar row that should
    /// appear selected. In three-column layouts that's the middle list; in the
    /// two-column case it's the full-width destination itself.
    var derivedMenuItem: NavigationItem {
        switch detailRoot {
        case .settings: return .settings
        case .about:    return .about
        default:        return contentRoot
        }
    }

    // MARK: - View factory

    /// The one place that maps a `NavigationItem` to its view. Every column and
    /// every `navigationDestination` routes through here, so a destination is
    /// rendered identically no matter how it was reached.
    @ViewBuilder
    func view(for item: NavigationItem) -> some View {
        switch item {
        case .authors:
            AuthorListView()
        case .books:
            BookListView()
        case .readingLists:
            ReadingListsView()
        case .search:
            SearchView()
        case .author(let author):
            AuthorDetailView(author: author)
        case .book(let book):
            BookDetailView(book: book)
        case .bookByAuthor(let book, _):
            BookDetailView(book: book)
        case .readingList(let list):
            ReadingListDetailView(list: list)
        case .settings:
            SettingsView()
        case .about:
            AboutView()
        case .selectSomething(let label, let systemImage):
            SelectSomethingView(label: label, systemImage: systemImage)
        }
    }
}
