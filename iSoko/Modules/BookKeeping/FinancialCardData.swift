//
//  FinancialCardData.swift
//  
//
//  Created by Edwin Weru on 15/03/2026.
//

import UIKit

public struct FinancialCardData {
    let title: String
    let icon: String
    let subtitle: String
    let statusText: String
    let statusColor: UIColor
    let statusIcon: String
    let backgroundColor: UIColor
    let action: (() -> Void)?
}
