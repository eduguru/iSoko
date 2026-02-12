//
//  BottomSheetModel.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//



import UIKit

public struct BottomSheetModel {

    public enum Style {
        case bottomSheet
        case floating
    }

    public enum ButtonStyle {
        case primary
        case secondary
    }

    public struct Button {
        public let title: String
        public let style: ButtonStyle
        public let isFullWidth: Bool
        public let action: () -> Void

        public init(
            title: String,
            style: ButtonStyle,
            isFullWidth: Bool = false,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.style = style
            self.isFullWidth = isFullWidth
            self.action = action
        }
    }

    public let style: Style
    public let icon: UIImage?
    public let title: String
    public let message: String?
    public let showCloseButton: Bool
    public let buttons: [Button]

    public init(
        style: Style,
        icon: UIImage? = nil,
        title: String,
        message: String? = nil,
        showCloseButton: Bool = false,
        buttons: [Button]
    ) {
        self.style = style
        self.icon = icon
        self.title = title
        self.message = message
        self.showCloseButton = showCloseButton
        self.buttons = buttons
    }
}
