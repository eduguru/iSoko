//
//  SimpleImageTitleGridModel.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import UIKit

public struct SimpleImageTitleGridModel {
    public let id: String
    public let image: UIImage?
    public let imageUrl: String?
    public let title: String
    public var onTap: (() -> Void)?

    public init(id: String, image: UIImage? = nil, imageUrl: String? = nil, title: String, onTap: (() -> Void)? = nil) {
        self.id = id
        self.image = image
        self.imageUrl = imageUrl
        self.title = title
        self.onTap = onTap
    }
}
