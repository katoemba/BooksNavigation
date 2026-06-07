//
//  NavigationItem.swift
//  BooksNavigation
//
//  A single Hashable enum is the entire vocabulary of navigation. Every place
//  the app can show — a list, a detail screen, a settings pane — is one case.
//  Because the associated values (Author, Book, ReadingList) are all Hashable,
//  Swift synthesises `Hashable` and `Equatable` for us: no hand-written
//  `==`/`hash(into:)` boilerplate required.
//

import SwiftUI

enum NavigationItem: Hashable, Identifiable {
    // Middle-column lists
    case authors
    case books
    case readingLists
    case search

    // Detail-column destinations
    case author(Author)
    case book(Book)
    /// A book opened from within an author's page. Carries the originating
    /// author so the detail screen knows its context; navigates the same as
    /// `.book`, but is a distinct value on the stack.
    case bookByAuthor(Book, Author)
    case readingList(ReadingList)

    // Full-width (two-column) destinations
    case settings
    case about

    /// Placeholder shown in the empty detail column before a selection is made.
    case selectSomething(label: String, systemImage: String)

    var id: Self { self }
}

extension NavigationItem {
    /// Drives the two- vs three-column layout. Screens that have no meaningful
    /// middle-column list (Settings, About) want the detail to span the space
    /// left of the sidebar, so they report two columns.
    var numberOfColumns: Int {
        switch self {
        case .settings, .about:
            return 2
        default:
            return 3
        }
    }
}

// MARK: - Sidebar presentation

extension NavigationItem {
    /// Items shown in the sidebar's "Browse" section.
    static let browseCases: [NavigationItem] = [.authors, .books, .readingLists, .search]

    /// Items shown in the sidebar's "More" section.
    static let otherCases: [NavigationItem] = [.settings, .about]

    var displayName: String {
        switch self {
        case .authors:                 return "Authors"
        case .books:                   return "Books"
        case .readingLists:            return "Reading Lists"
        case .search:                  return "Search"
        case .author(let author):      return author.name
        case .book(let book):          return book.title
        case .bookByAuthor(let book, _): return book.title
        case .readingList(let list):   return list.name
        case .settings:                return "Settings"
        case .about:                   return "About"
        case .selectSomething(let label, _): return label
        }
    }

    var iconName: String {
        switch self {
        case .authors:                 return "person.2"
        case .books:                   return "books.vertical"
        case .readingLists:            return "list.bullet.rectangle"
        case .search:                  return "magnifyingglass"
        case .author:                  return "person"
        case .book, .bookByAuthor:     return "book"
        case .readingList:             return "list.bullet.rectangle"
        case .settings:                return "gearshape"
        case .about:                   return "info.circle"
        case .selectSomething(_, let systemImage): return systemImage
        }
    }
}
