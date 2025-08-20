//
//  ButtonFormModel.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public struct ButtonFormModel {
    public let title: String
    public let style: ButtonStyleType
    public let size: StyledButton.ButtonSize
    public let icon: UIImage?
    public let fontStyle: FontStyle
    public let hapticsEnabled: Bool
    public let action: (() -> Void)?
    public var isEnabled: Bool
    public var isLoading: Bool

    public init(
        title: String,
        style: ButtonStyleType = .primary,
        size: StyledButton.ButtonSize = .medium,
        icon: UIImage? = nil,
        fontStyle: FontStyle = .callout,
        hapticsEnabled: Bool = false,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.icon = icon
        self.fontStyle = fontStyle
        self.hapticsEnabled = hapticsEnabled
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }
}
