//
//  TwoStatusCardsViewModel.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import Foundation

public struct TwoStatusCardsViewModel {
    enum Layout {
        case horizontal
        case vertical
    }

    let first: StatusCardViewModel?
    let second: StatusCardViewModel?
    let layout: Layout
    let spacing: CGFloat

    init(
        first: StatusCardViewModel?,
        second: StatusCardViewModel?,
        layout: Layout = .horizontal,
        spacing: CGFloat = 12
    ) {
        self.first = first
        self.second = second
        self.layout = layout
        self.spacing = spacing
    }
}
