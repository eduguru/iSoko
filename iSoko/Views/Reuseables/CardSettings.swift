//
//  CardSettings.swift
//  
//
//  Created by Edwin Weru on 02/04/2026.
//

import UIKit

public struct CardSettings {
    public var backgroundColor: UIColor
    public var cornerRadius: CGFloat
    public var borderColor: UIColor?
    public var borderWidth: CGFloat
    public var contentInsets: UIEdgeInsets
    
    public init(
        backgroundColor: UIColor = .white,
        cornerRadius: CGFloat = 12,
        borderColor: UIColor? = UIColor.separator,
        borderWidth: CGFloat = 1,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.contentInsets = contentInsets
    }
}

public extension CardSettings {
    
    static let `default` = CardSettings(
        backgroundColor: .white,
        cornerRadius: 12,
        borderColor: UIColor.separator,
        borderWidth: 1,
        contentInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    )
    
    static let subtle = CardSettings(
        backgroundColor: .secondarySystemBackground,
        cornerRadius: 12,
        borderColor: nil,
        borderWidth: 0,
        contentInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    )
    
    static let outlined = CardSettings(
        backgroundColor: .clear,
        cornerRadius: 12,
        borderColor: UIColor.separator,
        borderWidth: 1,
        contentInsets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    )
    
    static let compact = CardSettings(
        backgroundColor: .white,
        cornerRadius: 10,
        borderColor: UIColor.separator,
        borderWidth: 1,
        contentInsets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    )
}

public extension CardSettings {
    
    func with(
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        contentInsets: UIEdgeInsets? = nil
    ) -> CardSettings {
        
        return CardSettings(
            backgroundColor: backgroundColor ?? self.backgroundColor,
            cornerRadius: cornerRadius ?? self.cornerRadius,
            borderColor: borderColor ?? self.borderColor,
            borderWidth: borderWidth ?? self.borderWidth,
            contentInsets: contentInsets ?? self.contentInsets
        )
    }
}
