//
//  DualCardCellConfig.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import Foundation

public struct DualCardCellConfig {
    public let left: DualCardItemConfig
    public let right: DualCardItemConfig
    public let spacing: CGFloat

    public init(
        left: DualCardItemConfig,
        right: DualCardItemConfig,
        spacing: CGFloat = 12
    ) {
        self.left = left
        self.right = right
        self.spacing = spacing
    }
}
