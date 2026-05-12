//
//  UIFont+Swizzle.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import UIKit
import ObjectiveC.runtime

extension UIFont {

    // MARK: - Font Names
    private static let regular = "Poppins-Regular"
    private static let medium = "Poppins-Medium"
    private static let semiBold = "Poppins-SemiBold"
    private static let bold = "Poppins-Bold"

    // MARK: - Swizzled Methods
    @objc class func customSystemFont(
        ofSize size: CGFloat,
        weight: UIFont.Weight
    ) -> UIFont {

        switch weight {

        case .ultraLight,
             .thin,
             .light,
             .regular:
            return UIFont(name: regular, size: size)
                ?? UIFont.systemFont(ofSize: size)

        case .medium:
            return UIFont(name: medium, size: size)
                ?? UIFont.systemFont(ofSize: size)

        case .semibold:
            return UIFont(name: semiBold, size: size)
                ?? UIFont.boldSystemFont(ofSize: size)

        case .bold,
             .heavy,
             .black:
            return UIFont(name: bold, size: size)
                ?? UIFont.boldSystemFont(ofSize: size)

        default:
            return UIFont(name: regular, size: size)
                ?? UIFont.systemFont(ofSize: size)
        }
    }

    @objc class func customBoldSystemFont(
        ofSize size: CGFloat
    ) -> UIFont {

        return UIFont(name: bold, size: size)
            ?? UIFont.boldSystemFont(ofSize: size)
    }

    @objc class func customItalicSystemFont(
        ofSize size: CGFloat
    ) -> UIFont {

        return UIFont(name: regular, size: size)
            ?? UIFont.italicSystemFont(ofSize: size)
    }

    // MARK: - Override

    static func overrideFonts() {

        guard self == UIFont.self else { return }

        // systemFont(ofSize:weight:)
        if let originalMethod = class_getClassMethod(
            self,
            #selector(systemFont(ofSize:weight:))
        ),
        let swizzledMethod = class_getClassMethod(
            self,
            #selector(customSystemFont(ofSize:weight:))
        ) {

            method_exchangeImplementations(
                originalMethod,
                swizzledMethod
            )
        }

        // boldSystemFont(ofSize:)
        if let originalBoldMethod = class_getClassMethod(
            self,
            #selector(boldSystemFont(ofSize:))
        ),
        let swizzledBoldMethod = class_getClassMethod(
            self,
            #selector(customBoldSystemFont(ofSize:))
        ) {

            method_exchangeImplementations(
                originalBoldMethod,
                swizzledBoldMethod
            )
        }

        // italicSystemFont(ofSize:)
        if let originalItalicMethod = class_getClassMethod(
            self,
            #selector(italicSystemFont(ofSize:))
        ),
        let swizzledItalicMethod = class_getClassMethod(
            self,
            #selector(customItalicSystemFont(ofSize:))
        ) {

            method_exchangeImplementations(
                originalItalicMethod,
                swizzledItalicMethod
            )
        }
    }
}
