//
//  UIWindowScene+Extension.swift
//  
//
//  Created by Edwin Weru on 29/01/2026.
//

import UIKit

//extension UIWindowScene {
//    var keyWindow: UIWindow? {
//        windows.first { $0.isKeyWindow }
//    }
//}


extension UIWindowScene {
    var keyWindowSafe: UIWindow? {
        if Thread.isMainThread {
            return windows.first { $0.isKeyWindow }
        } else {
            var key: UIWindow?
            DispatchQueue.main.sync {
                key = windows.first { $0.isKeyWindow }
            }
            return key
        }
    }
}
