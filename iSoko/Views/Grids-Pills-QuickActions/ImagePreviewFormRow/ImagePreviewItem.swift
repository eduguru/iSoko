//
//  ImagePreviewItem.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit

public struct ImagePreviewItem {
    public let image: UIImage?
    public let fileName: String?

    public init(
        image: UIImage?,
        fileName: String? = nil
    ) {
        self.image = image
        self.fileName = fileName
    }
}
