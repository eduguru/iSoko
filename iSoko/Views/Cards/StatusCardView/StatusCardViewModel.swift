//
//  StatusCardViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit


struct StatusCardViewModel {

    // Content
    let title: String
    let image: UIImage?

    // Styling (optional)
    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let borderColor: UIColor?
    let borderWidth: CGFloat?

    // Shadow (optional override)
    let shadowColor: UIColor?
    let shadowOpacity: Float?
    let shadowRadius: CGFloat?
    let shadowOffset: CGSize?

    // Icon styling
    let iconTintColor: UIColor?

    // Text styling
    let textColor: UIColor?
    let font: UIFont?

    init(
        title: String,
        image: UIImage?,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        shadowColor: UIColor? = nil,
        shadowOpacity: Float? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        iconTintColor: UIColor? = nil,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.iconTintColor = iconTintColor
        self.textColor = textColor
        self.font = font
    }
}
