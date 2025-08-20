//
//  EllipsisType.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public enum EllipsisType {
    case tail
    case head
    case middle
    case none
    
    var lineBreakMode: NSLineBreakMode {
        switch self {
        case .tail: return .byTruncatingTail
        case .head: return .byTruncatingHead
        case .middle: return .byTruncatingMiddle
        case .none: return .byWordWrapping
        }
    }
}
