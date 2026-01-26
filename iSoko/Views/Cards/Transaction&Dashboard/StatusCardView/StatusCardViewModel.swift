//
//  StatusCardViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit


struct StatusCardViewModel {
    let title: String?
    let image: UIImage?

    // Existing styling properties
    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let borderColor: UIColor?
    let borderWidth: CGFloat?
    let shadowColor: UIColor?
    let shadowOpacity: Float?
    let shadowRadius: CGFloat?
    let shadowOffset: CGSize?
    let iconTintColor: UIColor?
    let textColor: UIColor?
    let font: UIFont?

    // NEW (optional, safe)
    let iconSize: CGSize?
    let fixedHeight: CGFloat?

    // NEW: Callback closure
    let onTapAction: (() -> Void)?

    init(
        title: String?,
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
        font: UIFont? = nil,
        iconSize: CGSize? = nil,
        fixedHeight: CGFloat? = nil,
        onTapAction: (() -> Void)? = nil  // Added closure here
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
        self.iconSize = iconSize
        self.fixedHeight = fixedHeight
        self.onTapAction = onTapAction  // Store the callback
    }
}
