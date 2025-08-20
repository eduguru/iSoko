//
//  MultiButtonFormModel.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import Foundation
import UIKit

public struct MultiButtonFormModel {
    public enum Layout {
        case vertical(spacing: CGFloat = 12)
        case horizontal(spacing: CGFloat = 12, distribution: UIStackView.Distribution = .fillEqually)
    }

    public let buttons: [ButtonFormModel]
    public let layout: Layout

    public init(buttons: [ButtonFormModel], layout: Layout = .vertical()) {
        self.buttons = buttons
        self.layout = layout
    }
}
