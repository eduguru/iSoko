//
//  PDFItem.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import Foundation
import QuickLook

import Foundation
import QuickLook

final class PDFItem: NSObject, QLPreviewItem {
    let url: URL
    let title: String?

    init(url: URL, title: String? = nil) {
        self.url = url
        self.title = title
    }

    // ✅ Match optional type expected by protocol
    var previewItemURL: URL? {
        return url
    }

    var previewItemTitle: String? {
        return title
    }
}
