//
//  StatsCardConfig.swift
//  
//
//  Created by Edwin Weru on 26/03/2026.
//

import UIKit

public struct StatsCardConfig {

    public var items: [StatsCardItem]
    public var showsBackground: Bool
    public var cornerRadius: CGFloat
    public var spacing: CGFloat

    public init(
        items: [StatsCardItem],
        showsBackground: Bool = true,
        cornerRadius: CGFloat = 16,
        spacing: CGFloat = 12
    ) {
        self.items = items
        self.showsBackground = showsBackground
        self.cornerRadius = cornerRadius
        self.spacing = spacing
    }
}
