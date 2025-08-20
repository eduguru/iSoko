//
//  CarouselItem.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public struct CarouselItem {
    public let image: UIImage?
    public let text: String?
    public let textColor: UIColor
    public let didTap: (() -> Void)?

    public init(image: UIImage? = nil,
                text: String? = nil,
                textColor: UIColor = .white,
                didTap: (() -> Void)? = nil) {
        self.image = image
        self.text = text
        self.textColor = textColor
        self.didTap = didTap
    }
}

extension CarouselItem: Equatable {
    
    public static func == (lhs: CarouselItem, rhs: CarouselItem) -> Bool {
        lhs.text == rhs.text && lhs.textColor == rhs.textColor
    }
}
