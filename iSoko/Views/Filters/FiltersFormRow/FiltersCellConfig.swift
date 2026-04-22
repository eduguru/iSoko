//
//  FiltersCellConfig.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

// MARK: - Cell Config
public struct FiltersCellConfig {

    public let title: String?
    public let rows: [[FilterFieldConfig]]

    public let message: String?
    public let messageColor: UIColor

    public let showsCard: Bool

    public init(
        title: String? = nil,
        rows: [[FilterFieldConfig]],
        message: String? = nil,
        messageColor: UIColor = .secondaryLabel,
        showsCard: Bool = false
    ) {
        self.title = title
        self.rows = rows
        self.message = message
        self.messageColor = messageColor
        self.showsCard = showsCard
    }
}
