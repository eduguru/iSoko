//
//  PromoCodeModel.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

public struct PromoCodeModel {

    public var title: String

    public var code: String

    public var subtitle: String?

    public var buttonTitle: String

    public var cardSettings: CardSettings

    public var onCopyTapped: (() -> Void)?

    public init(
        title: String,
        code: String,
        subtitle: String? = nil,
        buttonTitle: String = "Copy Code",
        cardSettings: CardSettings = .default,
        onCopyTapped: (() -> Void)? = nil
    ) {
        self.title = title
        self.code = code
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.cardSettings = cardSettings
        self.onCopyTapped = onCopyTapped
    }
}
