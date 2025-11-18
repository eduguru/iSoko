//
//  NavigationBarButtonConfig.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import UIKit

// Define a model for configuring a button
public struct NavigationBarButtonConfig {
    public var title: String?
    public var image: UIImage?
    public var action: (() -> Void)?
    public var textColor: UIColor?
    public var imageColor: UIColor?
    
    public init(
        title: String? = nil,
        image: UIImage? = nil,
        action: (() -> Void)? = nil,
        textColor: UIColor? = .app(.primary),
        imageColor: UIColor? = .app(.primary)) {
        self.title = title
        self.image = image
        self.action = action
        self.textColor = textColor
        self.imageColor = imageColor
    }
}

// Define a model to configure both left and right buttons in the navigation bar
public struct NavigationBarConfig {
    public var leftButton: NavigationBarButtonConfig?
    public var rightButton: NavigationBarButtonConfig?
    
    public init(leftButton: NavigationBarButtonConfig? = nil, rightButton: NavigationBarButtonConfig? = nil) {
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
}
