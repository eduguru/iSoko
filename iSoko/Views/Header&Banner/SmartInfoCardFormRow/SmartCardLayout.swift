//
//  SmartCardLayout.swift
//  
//
//  Created by Edwin Weru on 01/05/2026.
//

import UIKit

public enum SmartCardLayout {
    case profile
    case summary
    case compact
}

public enum InfoItemStyle {
    case normal
    case link(textColor: UIColor = .systemGreen)
    case muted(textColor: UIColor = .secondaryLabel)
    case status(CardStatusStyle)
}
