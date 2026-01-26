//
//  CardStyle.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

public enum CardStyle {
    case none
    case border
    case shadow
    case borderAndShadow
}

extension CardStyle {

    struct Appearance {
        let backgroundColor: UIColor
        let borderColor: UIColor?
        let borderWidth: CGFloat
        let cornerRadius: CGFloat
        let shadow: Shadow?
    }

    struct Shadow {
        let color: UIColor
        let opacity: Float
        let radius: CGFloat
        let offset: CGSize
    }

    func appearance(
        cornerRadius: CGFloat = 16
    ) -> Appearance {

        switch self {
        case .none:
            return Appearance(
                backgroundColor: .clear,
                borderColor: nil,
                borderWidth: 0,
                cornerRadius: cornerRadius,
                shadow: nil
            )

        case .border:
            return Appearance(
                backgroundColor: .systemBackground,
                borderColor: .systemGray4,
                borderWidth: 1,
                cornerRadius: cornerRadius,
                shadow: nil
            )

        case .shadow:
            return Appearance(
                backgroundColor: .systemBackground,
                borderColor: nil,
                borderWidth: 0,
                cornerRadius: cornerRadius,
                shadow: Shadow(
                    color: .black,
                    opacity: 0.1,
                    radius: 8,
                    offset: CGSize(width: 0, height: 4)
                )
            )

        case .borderAndShadow:
            return Appearance(
                backgroundColor: .systemBackground,
                borderColor: .systemGray4,
                borderWidth: 1,
                cornerRadius: cornerRadius,
                shadow: Shadow(
                    color: .black,
                    opacity: 0.08,
                    radius: 6,
                    offset: CGSize(width: 0, height: 3)
                )
            )
        }
    }
}
