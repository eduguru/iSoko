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

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        // Configure checkbox button
        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)

        checkbox.adjustsImageWhenHighlighted = false
        checkbox.showsTouchWhenHighlighted = false
        checkbox.backgroundColor = .clear
        checkbox.layer.backgroundColor = UIColor.clear.cgColor
        checkbox.tintAdjustmentMode = .normal

        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        // Configure description text view
        descriptionLabel.isEditable = false
        descriptionLabel.isScrollEnabled = false
        descriptionLabel.delegate = self
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textContainerInset = .zero
        descriptionLabel.textContainer.lineFragmentPadding = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout stack
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
            checkbox.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    public func configure(with config: TermsCheckboxRowConfig) {
        self.config = config

        checkbox.isSelected = config.isAgreed
        checkbox.tintColor = config.checkboxTintColor

        let attributed = NSMutableAttributedString(string: config.descriptionText)
        attributed.addAttributes([
            .font: config.font,
            .foregroundColor: config.textColor
        ], range: NSRange(location: 0, length: attributed.length))

        if let termsRange = config.termsLinkRange {
            attributed.addAttribute(.link, value: "terms://", range: termsRange)
        }

        if let privacyRange = config.privacyLinkRange {
            attributed.addAttribute(.link, value: "privacy://", range: privacyRange)
        }

        descriptionLabel.attributedText = attributed
        descriptionLabel.linkTextAttributes = [
            .foregroundColor: config.checkboxTintColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        applyCardStyleIfNeeded(config)
    }

    private func applyCardStyleIfNeeded(_ config: TermsCheckboxRowConfig) {
        if config.useCardStyle {
            contentView.backgroundColor = config.cardBackgroundColor
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = false
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOpacity = 0.05
            contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.layer.shadowRadius = 4
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.cornerRadius = 0
            contentView.layer.shadowOpacity = 0
            contentView.layer.shadowRadius = 0
            contentView.layer.shadowOffset = .zero
        }
    }

    @objc private func toggleCheckbox() {
        checkbox.isSelected.toggle()
        config?.onToggle?(checkbox.isSelected)
    }

    // MARK: - UITextViewDelegate

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "terms://" {
            config?.onTermsTapped?()
        } else if URL.absoluteString == "privacy://" {
            config?.onPrivacyTapped?()
        }
        return false
    }
}
