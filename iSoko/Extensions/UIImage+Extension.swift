//
//  UIImage+Extension.swift
//  UtilsKit
//
//  Created by Edwin Weru on 18/09/2025.
//

import UIKit
import SwiftUI

public extension UIImage {
    static func fromEmoji(_ emoji: String, size: CGFloat = 40) -> UIImage? {
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: size)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)

        UIGraphicsBeginImageContextWithOptions(label.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        label.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}


public extension Image {
    init?(emoji: String, size: CGFloat = 40) {
        guard let uiImage = UIImage.fromEmoji(emoji, size: size) else { return nil }
        self = Image(uiImage: uiImage)
    }
}
