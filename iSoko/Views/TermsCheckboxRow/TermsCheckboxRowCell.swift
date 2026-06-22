//
//  TermsCheckboxRowCell.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit

public final class TermsCheckboxRowCell: UITableViewCell, UITextViewDelegate {

    private let checkbox = UIButton(type: .custom)
    private let descriptionLabel = UITextView()

    private var config: TermsCheckboxRowConfig?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        config = nil
        checkbox.isSelected = false
        descriptionLabel.attributedText = nil
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkbox.adjustsImageWhenHighlighted = false
        checkbox.showsTouchWhenHighlighted = false
        checkbox.backgroundColor = .clear
        checkbox.layer.backgroundColor = UIColor.clear.cgColor
        checkbox.tintAdjustmentMode = .normal
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.isEditable = false
        descriptionLabel.isSelectable = true
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.delegate = self
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textContainerInset = .zero
        descriptionLabel.textContainer.lineFragmentPadding = 0
        descriptionLabel.dataDetectorTypes = []
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [checkbox, descriptionLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    public func configure(with config: TermsCheckboxRowConfig) {
        self.config = config

        checkbox.isSelected = config.isAgreed
        checkbox.tintColor = config.checkboxTintColor

        let attributed = NSMutableAttributedString(string: config.descriptionText)
        let fullRange = NSRange(location: 0, length: attributed.length)

        attributed.addAttributes([
            .font: config.font,
            .foregroundColor: config.textColor
        ], range: fullRange)

        applyLocalizedLink(
            to: attributed,
            explicitRange: config.termsLinkRange,
            localizedKeys: [
                "common.terms_of_use",
                "common.terms",
                "terms_of_use"
            ],
            fallbackTexts: [
                "terms of use",
                "terms"
            ],
            url: "app://terms"
        )

        applyLocalizedLink(
            to: attributed,
            explicitRange: config.privacyLinkRange,
            localizedKeys: [
                "common.help_feedback.privacy_policy",
                "common.privacy_policy",
                "privacy_policy"
            ],
            fallbackTexts: [
                "privacy policy",
                "privacy"
            ],
            url: "app://privacy"
        )

        descriptionLabel.attributedText = attributed
        descriptionLabel.linkTextAttributes = [
            .foregroundColor: config.checkboxTintColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        applyCardStyleIfNeeded(config)
    }

    private func applyLocalizedLink(
        to attributed: NSMutableAttributedString,
        explicitRange: NSRange?,
        localizedKeys: [String],
        fallbackTexts: [String],
        url: String
    ) {
        if let validRange = validRange(explicitRange, maxLength: attributed.length) {
            attributed.addAttribute(.link, value: url, range: validRange)
            return
        }

        let candidates = localizedKeys.map { $0.localized } + fallbackTexts

        guard let range = firstMatchingRange(
            in: attributed.string,
            candidates: candidates
        ) else {
            return
        }

        attributed.addAttribute(.link, value: url, range: range)
    }

    private func firstMatchingRange(
        in text: String,
        candidates: [String]
    ) -> NSRange? {
        let nsText = text as NSString

        for candidate in candidates {
            let trimmed = candidate.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmed.isEmpty else { continue }

            let range = nsText.range(
                of: trimmed,
                options: [
                    .caseInsensitive,
                    .diacriticInsensitive
                ]
            )

            if range.location != NSNotFound {
                return range
            }
        }

        return nil
    }

    private func validRange(_ range: NSRange?, maxLength: Int) -> NSRange? {
        guard let range,
              range.location != NSNotFound,
              range.location >= 0,
              range.length > 0,
              NSMaxRange(range) <= maxLength else {
            return nil
        }

        return range
    }

    private func applyCardStyleIfNeeded(_ config: TermsCheckboxRowConfig) {
        if config.useCardStyle {
            contentView.backgroundColor = config.cardBackgroundColor
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = true
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = false
        }
    }

    @objc private func toggleCheckbox() {
        checkbox.isSelected.toggle()
        config?.onToggle?(checkbox.isSelected)
    }

    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        switch URL.absoluteString {
        case "app://terms":
            config?.onTermsTapped?()
        case "app://privacy":
            config?.onPrivacyTapped?()
        default:
            break
        }

        return false
    }
}
