//
//  RegularContentView.swift
//  BooksNavigation
//
//  The NavigationSplitView host. The only structural decision it makes is
//  whether to show three columns (sidebar + list + detail) or two columns
//  (sidebar + full-width detail), based on the detail root's metadata.
//

import SwiftUI

struct RegularContentView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    var body: some View {
        if router.detailRoot.numberOfColumns == 3 {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                sidebar
            } content: {
                NavigationStack {
                    router.view(for: router.contentRoot)
                }
                .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 380)
            } detail: {
                detailColumn
            }
        } else {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                sidebar
            } detail: {
                detailColumn
            }
        }
    }

    private var sidebar: some View {
        SidebarView()
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
    }

    /// The detail column is identical in both layouts: a stack rooted at
    /// `detailRoot`, pushing further `NavigationItem`s onto `detailStack`.
    private var detailColumn: some View {
        NavigationStack(path: detailStackBinding) {
            router.view(for: router.detailRoot)
                .navigationDestination(for: NavigationItem.self) { item in
                    router.view(for: item)
                }
        }
    }

    private var detailStackBinding: Binding<[NavigationItem]> {
        Binding(
            get: { router.detailStack },
            set: { router.detailStack = $0 }
        )
    }
}
