//
//  TitleDropDownFilterModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

struct TitleDropDownFilterModel {

    // Content
    let title: String?
    let description: String?
    let filterTitle: String?
    let filterIcon: UIImage?

    // Styling
    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let isHidden: Bool?

    // Action
    let onFilterTap: (() -> Void)?

    init(
        title: String? = nil,
        description: String? = nil,
        filterTitle: String? = nil,
        filterIcon: UIImage? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        isHidden: Bool? = nil,
        onFilterTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.filterTitle = filterTitle
        self.filterIcon = filterIcon
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.isHidden = isHidden
        self.onFilterTap = onFilterTap
    }
}
