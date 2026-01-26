//
//  TransactionHeaderCellConfig.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

struct TransactionHeaderCellConfig {

    let title: String
    let titleIcon: UIImage?

    let leftColumn: [InfoCardCellConfig.Row]
    let rightColumn: [InfoCardCellConfig.Row]

    let statusText: String
    let statusTextColor: UIColor
    let statusBackgroundColor: UIColor

    let cardStyle: CardStyle
}
