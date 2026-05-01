//
//  InfoItem.swift
//  
//
//  Created by Edwin Weru on 01/05/2026.
//

import UIKit

public struct InfoItem {

    public let text: String?
    public let icon: UIImage?

    public init(text: String?, icon: UIImage? = nil) {
        self.text = text
        self.icon = icon
    }
}
