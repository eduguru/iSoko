//
//  CarouselModel.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public enum PaginationPlacement {
    case below
    case inside
}

public enum TransitionStyle {
    case none
    case fade
    case slideLeft
    case slideRight
}

public struct CarouselModel {
    public var items: [CarouselItem]
    public var autoPlayInterval: TimeInterval
    public var paginationPlacement: PaginationPlacement
    public var imageContentMode: UIView.ContentMode
    public var transitionStyle: TransitionStyle
    public var hideText: Bool
    public var currentPageDotColor: UIColor?
    public var pageDotColor: UIColor?

    public init(
        items: [CarouselItem],
        autoPlayInterval: TimeInterval = 3.0,
        paginationPlacement: PaginationPlacement = .below,
        imageContentMode: UIView.ContentMode = .scaleAspectFill,
        transitionStyle: TransitionStyle = .slideRight,
        hideText: Bool = false,
        currentPageDotColor: UIColor? = nil,
        pageDotColor: UIColor? = nil
    ) {
        self.items = items
        self.autoPlayInterval = autoPlayInterval
        self.paginationPlacement = paginationPlacement
        self.imageContentMode = imageContentMode
        self.transitionStyle = transitionStyle
        self.hideText = hideText
        self.currentPageDotColor = currentPageDotColor
        self.pageDotColor = pageDotColor
    }
}
