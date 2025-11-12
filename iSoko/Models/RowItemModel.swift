//
//  RowItemModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import UIKit

public struct RowItemModel {
    let title: String
    let description: String
    let image: UIImage
    let bottomLabelText: String?
    let bottomButtonTitle: String?
    let bottomButtonStyle: ImageTitleDescriptionBottomConfig.BottomButtonStyle?
    let onTap: (() -> Void)?

    public init(
        title: String,
        description: String,
        image: UIImage,
        bottomLabelText: String? = nil,
        bottomButtonTitle: String? = nil,
        bottomButtonStyle: ImageTitleDescriptionBottomConfig.BottomButtonStyle? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.image = image
        self.bottomLabelText = bottomLabelText
        self.bottomButtonTitle = bottomButtonTitle
        self.bottomButtonStyle = bottomButtonStyle
        self.onTap = onTap
    }
}
