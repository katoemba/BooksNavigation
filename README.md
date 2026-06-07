# BooksNavigation

A minimal SwiftUI sample showing how to drive a `NavigationSplitView` with a
small **navigation router**, supporting both **three-column** (sidebar + list +
detail) and **two-column** (sidebar + full-width detail) layouts from the same
state.

It accompanies the blog post *“A NavigationRouter for SwiftUI’s
NavigationSplitView”*. The app is themed around a tiny offline library of books
and authors — no networking, no dependencies, all data is in memory.

> Targets **macOS** and **iPadOS** (the regular, multi-column size class). There
> is intentionally no separate compact / iPhone layout — `NavigationSplitView`
> collapses to a stack on its own when space is tight.

<!-- Add a screenshot/GIF here for the blog post, e.g. docs/screenshot.png -->
<!-- ![Three- and two-column layouts](docs/screenshot.png) -->

## The idea

SwiftUI gives you `NavigationSplitView` and `NavigationStack`, but wiring them
together gets messy when navigation logic is scattered across views via
`NavigationLink`. This sample centralises three things:

### 1. `NavigationItem` — one Hashable enum as the navigation vocabulary

Every place the app can show is a single `enum` case. Associated values carry
the payload (`.author(Author)`, `.book(Book)`). Because those payloads are
`Hashable`, Swift synthesises `Hashable`/`Equatable` for free — no hand-written
`==`/`hash(into:)`.

Each case also carries its own metadata: `numberOfColumns`, `displayName`,
`iconName`.

See [`NavigationItem.swift`](BooksNavigation/Navigation/NavigationItem.swift).

### 2. `NavigationRouter` — owns the state, exposes intent

An `@Observable @MainActor` class holding `contentRoot` (middle column),
`detailRoot` (detail column root) and `detailStack` (the pushed stack). Views
never poke a `NavigationStack` path directly; they call `setContentRoot`,
`setDetailRoot`, or `push`.

It also hosts the single `view(for:)` factory that maps any `NavigationItem` to
its view, so a destination renders identically no matter how it was reached.

See [`NavigationRouter.swift`](BooksNavigation/Navigation/NavigationRouter.swift).

### 3. `RegularContentView` — the 2 ↔ 3 column switch

The host reads `router.detailRoot.numberOfColumns` and chooses a three-column or
two-column `NavigationSplitView`. The detail column is the same in both: a
`NavigationStack` rooted at `detailRoot`, pushing onto `detailStack`.

See [`RegularContentView.swift`](BooksNavigation/Navigation/RegularContentView.swift).

## How navigation flows

```
Sidebar selection ──► router.setContentRoot(item)
                        • sets contentRoot (middle list)
                        • resets detailRoot to a placeholder
                        • 2-column items (Settings/About) skip the middle list

Row in middle list ──► router.setDetailRoot(.book(book))   // replaces detail root
Link inside detail ──► router.push(.author(author))        // pushes on the stack
```

## Project layout

```
BooksNavigation/
├── BooksNavigationApp.swift        // @main, builds Library + Router
├── Model/
│   └── Library.swift               // value types + in-memory sample data
├── Navigation/
│   ├── NavigationItem.swift        // the navigation vocabulary
│   ├── NavigationRouter.swift      // state + intent + view factory
│   ├── RegularContentView.swift    // the NavigationSplitView host
│   └── SidebarView.swift           // first column
└── Views/                          // leaf screens (lists + detail)
```

## Running

Open `BooksNavigation.xcodeproj` in Xcode 16 or later and run on **My Mac** or an
**iPad** simulator.

## License

MIT — do whatever you like with it.
