//
//  UIWindowScene+Extension.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import UIKit

extension UIWindowScene {
    var keyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}
