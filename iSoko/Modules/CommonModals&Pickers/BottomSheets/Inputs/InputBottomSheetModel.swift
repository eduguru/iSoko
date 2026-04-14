//
//  InputBottomSheetModel.swift
//  
//
//  Created by Edwin Weru on 13/04/2026.
//

import UIKit

public struct InputBottomSheetModel {

    public enum Field {
        case text(TextField)
    }

    public struct TextField {
        public let id: String
        public let placeholder: String
        public let keyboardType: UIKeyboardType
        public let isSecure: Bool

        public init(
            id: String,
            placeholder: String,
            keyboardType: UIKeyboardType = .default,
            isSecure: Bool = false
        ) {
            self.id = id
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.isSecure = isSecure
        }
    }

    public struct Action {
        public let title: String
        public let style: BottomSheetModel.ButtonStyle
        public let handler: ([String: String]) -> Void

        public init(
            title: String,
            style: BottomSheetModel.ButtonStyle,
            handler: @escaping ([String: String]) -> Void
        ) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }

    public let title: String
    public let message: String?
    public let fields: [Field]
    public let actions: [Action]
}
