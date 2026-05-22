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
        
        // <-- Add this property
        public let shouldDismiss: Bool

        public init(
            title: String,
            style: ButtonStyle,
            isFullWidth: Bool = false,
            shouldDismiss: Bool = true, // default to true
            action: @escaping () -> Void
        ) {
            self.title = title
            self.style = style
            self.isFullWidth = isFullWidth
            self.shouldDismiss = shouldDismiss
            self.action = action
        }
    }

    public struct BottomSheetItem {
        public let id: String
        public let title: String
        public let image: UIImage?
        public var isSelected: Bool

        public init(
            id: String,
            title: String,
            image: UIImage? = nil,
            isSelected: Bool = false
        ) {
            self.id = id
            self.title = title
            self.image = image
            self.isSelected = isSelected
        }
    }

    public enum State {
        case normal
        case success
        case error
    }

    public let style: Style
    public let icon: UIImage?
    public let title: String
    public let message: String?
    public let showCloseButton: Bool
    public let buttons: [Button]
    public let state: State

    // New properties for item list
    public var items: [BottomSheetItem]?
    public var onItemSelected: ((BottomSheetItem) -> Void)?

    public init(
        style: Style,
        icon: UIImage? = nil,
        title: String,
        message: String? = nil,
        showCloseButton: Bool = false,
        state: State = .normal,
        buttons: [Button] = [],
        items: [BottomSheetItem]? = nil,
        onItemSelected: ((BottomSheetItem) -> Void)? = nil
    ) {
        self.style = style
        self.icon = icon
        self.title = title
        self.message = message
        self.showCloseButton = showCloseButton
        self.state = state
        self.buttons = buttons
        self.items = items
        self.onItemSelected = onItemSelected
    }
}
