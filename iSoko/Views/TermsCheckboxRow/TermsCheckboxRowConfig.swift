//
//  TermsCheckboxRowConfig.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit

public struct TermsCheckboxRowConfig {
    public var isAgreed: Bool
    public var descriptionText: String
    public var termsLinkRange: NSRange?
    public var privacyLinkRange: NSRange?
    public var onToggle: ((Bool) -> Void)?
    public var onTermsTapped: (() -> Void)?
    public var onPrivacyTapped: (() -> Void)?
    public var checkboxTintColor: UIColor
    public var textColor: UIColor
    public var font: UIFont

    // Card style config
    public var useCardStyle: Bool
    public var cardBackgroundColor: UIColor

    public init(
        isAgreed: Bool = false,
        descriptionText: String,
        termsLinkRange: NSRange? = nil,
        privacyLinkRange: NSRange? = nil,
        onToggle: ((Bool) -> Void)? = nil,
        onTermsTapped: (() -> Void)? = nil,
        onPrivacyTapped: (() -> Void)? = nil,
        checkboxTintColor: UIColor = .systemBlue,
        textColor: UIColor = .label,
        font: UIFont = UIFont.preferredFont(forTextStyle: .footnote),
        useCardStyle: Bool = false,
        cardBackgroundColor: UIColor = .secondarySystemGroupedBackground
    ) {
        self.isAgreed = isAgreed
        self.descriptionText = descriptionText
        self.termsLinkRange = termsLinkRange
        self.privacyLinkRange = privacyLinkRange
        self.onToggle = onToggle
        self.onTermsTapped = onTermsTapped
        self.onPrivacyTapped = onPrivacyTapped
        self.checkboxTintColor = checkboxTintColor
        self.textColor = textColor
        self.font = font
        self.useCardStyle = useCardStyle
        self.cardBackgroundColor = cardBackgroundColor
    }
}

