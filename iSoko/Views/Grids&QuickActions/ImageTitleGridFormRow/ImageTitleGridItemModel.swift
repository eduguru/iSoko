//
//  ImageTitleGridItemModel.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit

public struct ImageTitleGridItemModel {
    public let id: String
    public let image: UIImage?
    public let imageUrl: String?
    public let title: String
    public let subtitle: String?
    
    public var onTap: (() -> Void)?
    
    public init(
        id: String,
        image: UIImage? = nil,
        imageUrl: String? = nil,
        title: String,
        subtitle: String? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.id = id
        self.image = image
        self.imageUrl = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.onTap = onTap
    }
}
