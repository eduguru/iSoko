//
//  OpportunityItem.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public struct OpportunityItem {
    public let id: String
    public let image: UIImage?
    public let title: String
    public let subtitle: String?
    public let location: String?
    public let category: String?
    public let onTap: (() -> Void)?
}
