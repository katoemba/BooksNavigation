//
//  ReadingListsView.swift
//  BooksNavigation
//
//  Middle column. Selecting a reading list replaces the detail column's root.
//

import SwiftUI

struct ReadingListsView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(Library.self) private var library

    var body: some View {
        List {
            ForEach(library.readingLists) { list in
                SelectionRow {
                    router.setDetailRoot(.readingList(list))
                } content: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(list.name)
                            .font(.headline)
                        Text("\(list.bookIDs.count) books")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Reading Lists")
    }
}

#Preview {
    NavigationStack {
        ReadingListsView()
    }
    .environment(Library())
    .environment(NavigationRouter())
}
