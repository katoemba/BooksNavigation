// make_icon.swift
//
// Renders the BooksNavigation app icon (a small stack of books on an indigo
// gradient) at every size the asset catalog needs, using CoreGraphics so there
// are no external dependencies. Run with:
//
//     swift scripts/make_icon.swift
//
// It writes PNGs into BooksNavigation/Assets.xcassets/AppIcon.appiconset/.

import AppKit
import CoreGraphics

let outputDir = "BooksNavigation/Assets.xcassets/AppIcon.appiconset"

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r/255, green: g/255, blue: b/255, alpha: a)
}

func roundedRectPath(_ rect: CGRect, radius: CGFloat) -> CGPath {
    CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
}

/// Draws the icon into `ctx` for a canvas of `size` x `size` points.
/// All artwork is authored in a 1024-pt space and scaled to `size`.
func drawIcon(into ctx: CGContext, size: CGFloat) {
    let s = size / 1024.0

    // Flip to a top-left origin so y grows downward (easier to reason about).
    ctx.translateBy(x: 0, y: size)
    ctx.scaleBy(x: 1, y: -1)
    ctx.scaleBy(x: s, y: s)

    // Background gradient.
    let cs = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(
        colorsSpace: cs,
        colors: [color(58, 44, 122), color(91, 63, 160)] as CFArray,
        locations: [0, 1]
    )!
    ctx.saveGState()
    ctx.addRect(CGRect(x: 0, y: 0, width: 1024, height: 1024))
    ctx.clip()
    ctx.drawLinearGradient(
        gradient,
        start: CGPoint(x: 0, y: 0),
        end: CGPoint(x: 0, y: 1024),
        options: []
    )
    ctx.restoreGState()

    // Shelf line beneath the books.
    ctx.addPath(roundedRectPath(CGRect(x: 270, y: 716, width: 484, height: 26), radius: 13))
    ctx.setFillColor(color(0, 0, 0, 0.22))
    ctx.fillPath()

    // Upright books, standing on the shelf (baseline y = 720).
    struct Book { let x: CGFloat; let w: CGFloat; let h: CGFloat; let c: CGColor }
    let baseline: CGFloat = 720
    let books: [Book] = [
        Book(x: 300, w: 112, h: 300, c: color(242, 181, 68)),  // amber
        Book(x: 428, w: 112, h: 384, c: color(63, 182, 168)),  // teal
        Book(x: 556, w: 112, h: 332, c: color(232, 102, 91)),  // coral
        Book(x: 684, w: 112, h: 286, c: color(201, 184, 240)), // lavender
    ]

    for book in books {
        let rect = CGRect(x: book.x, y: baseline - book.h, width: book.w, height: book.h)
        ctx.addPath(roundedRectPath(rect, radius: 18))
        ctx.setFillColor(book.c)
        ctx.fillPath()

        // Spine highlight stripe near the top.
        let band = CGRect(x: book.x + 16, y: rect.minY + 34, width: book.w - 32, height: 18)
        ctx.addPath(roundedRectPath(band, radius: 9))
        ctx.setFillColor(color(255, 255, 255, 0.55))
        ctx.fillPath()

        // A second, shorter stripe.
        let band2 = CGRect(x: book.x + 16, y: rect.minY + 70, width: book.w - 52, height: 14)
        ctx.addPath(roundedRectPath(band2, radius: 7))
        ctx.setFillColor(color(255, 255, 255, 0.35))
        ctx.fillPath()
    }
}

func writePNG(size: Int, to path: String) {
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: size,
        pixelsHigh: size,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    let nsCtx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = nsCtx
    drawIcon(into: nsCtx.cgContext, size: CGFloat(size))
    NSGraphicsContext.restoreGraphicsState()

    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: URL(fileURLWithPath: path))
    print("wrote \(path)")
}

let sizes = [16, 32, 64, 128, 256, 512, 1024]
for size in sizes {
    writePNG(size: size, to: "\(outputDir)/icon_\(size).png")
}
