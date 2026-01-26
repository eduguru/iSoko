//
//  PaddingLabel.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

// MARK: - PaddingLabel (for status pill)
public class PaddingLabel: UILabel {
    var paddingTop: CGFloat = 0
    var paddingBottom: CGFloat = 0
    var paddingLeft: CGFloat = 0
    var paddingRight: CGFloat = 0

    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        super.drawText(in: rect.inset(by: insets))
    }

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += paddingTop + paddingBottom
        size.width += paddingLeft + paddingRight
        return size
    }
}
