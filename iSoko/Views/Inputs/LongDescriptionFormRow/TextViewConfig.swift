//
//  TextViewConfig.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

public struct TextViewConfig {
    // The prefix label that appears before the text view
    public var prefixText: String?
    
    // Optional image to be shown on the right of the text view (like an eye icon for password toggle, etc.)
    public var accessoryImage: UIImage?
    
    // Whether the text view should be scrollable
    public var isScrollable: Bool = true
    
    // Optional height constraint for the text view (if you want to set a fixed height)
    public var fixedHeight: CGFloat?
    
    // Whether the text view is read-only
    public var isReadOnly: Bool = false
    
    // Return key type for the text view (e.g., `.done`, `.next`)
    public var returnKeyType: UIReturnKeyType = .default

    // MARK: - Init
    
    public init(
        prefixText: String? = nil,
        accessoryImage: UIImage? = nil,
        isScrollable: Bool = true,
        fixedHeight: CGFloat? = nil,
        isReadOnly: Bool = false,
        returnKeyType: UIReturnKeyType = .default
    ) {
        self.prefixText = prefixText
        self.accessoryImage = accessoryImage
        self.isScrollable = isScrollable
        self.fixedHeight = fixedHeight
        self.isReadOnly = isReadOnly
        self.returnKeyType = returnKeyType
    }
}
