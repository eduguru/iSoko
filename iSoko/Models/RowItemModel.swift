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
    let onBottomButtonTap: (() -> Void)?
    let onTap: (() -> Void)?

    public init(
        title: String,
        description: String,
        image: UIImage,
        bottomLabelText: String? = nil,
        bottomButtonTitle: String? = nil,
        bottomButtonStyle: ImageTitleDescriptionBottomConfig.BottomButtonStyle? = nil,
        onBottomButtonTap: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.image = image
        self.bottomLabelText = bottomLabelText
        self.bottomButtonTitle = bottomButtonTitle
        self.bottomButtonStyle = bottomButtonStyle
        self.onBottomButtonTap = onBottomButtonTap
        self.onTap = onTap
    }
}
