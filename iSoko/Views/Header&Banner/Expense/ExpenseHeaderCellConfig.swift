//
//  ExpenseHeaderCellConfig.swift
//  
//
//  Created by Edwin Weru on 24/01/2026.
//

import UIKit

struct ExpenseHeaderCellConfig {

    let title: String
    let titleIcon: UIImage?

    let amountText: NSAttributedString

    let rows: [InfoCardCellConfig.Row]

    let paymentText: String
    let paymentTextColor: UIColor
    let paymentBackgroundColor: UIColor

    let dateText: NSAttributedString
    let cardStyle: CardStyle
}
