//
//  SimpleInputFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

// MARK: - SimpleInputFormCell

final class SimpleInputFormCell: UITableViewCell {

    // MARK: - UI Components
    private let containerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let cardContainerView = UIView()
    private let stackView = UIStackView()
    private let prefixLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()
    private let accessoryImageView = UIImageView()
    private let toggleButton = UIButton(type: .system)

    private var model: SimpleInputModel?
    private var isPasswordVisible = false

    // Public callback
    var onTextChanged: ((String) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none

        // Main vertical stack
        containerStackView.axis = .vertical
        containerStackView.spacing = 4
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        // Title Label — always added, initially hidden
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.isHidden = true
        containerStackView.addArrangedSubview(titleLabel)

        // Card Container
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.clipsToBounds = false
        containerStackView.addArrangedSubview(cardContainerView)

        // Inner horizontal stack
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.addSubview(stackView)

        // Prefix
        prefixLabel.font = .systemFont(ofSize: 16)
        prefixLabel.textColor = .darkGray
        prefixLabel.setContentHuggingPriority(.required, for: .horizontal)

        // TextField
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        // Accessory Image
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.tintColor = .gray
        accessoryImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        accessoryImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        accessoryImageView.setContentHuggingPriority(.required, for: .horizontal)

        // Toggle button
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        toggleButton.isHidden = true
        toggleButton.setContentHuggingPriority(.required, for: .horizontal)

        stackView.addArrangedSubview(prefixLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(toggleButton)
        stackView.addArrangedSubview(accessoryImageView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),
            cardContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        // Error Label
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        containerStackView.addArrangedSubview(errorLabel)
        errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }

    // MARK: - Configuration
    func configure(with model: SimpleInputModel) {
        self.model = model
        let config = model.config

        // Title — hide if empty
        titleLabel.text = model.titleText
        titleLabel.isHidden = model.titleText?.isEmpty ?? true

        // TextField
        textField.text = model.text
        textField.placeholder = config.placeholder
        textField.keyboardType = config.keyboardType
        textField.returnKeyType = config.returnKeyType
        textField.autocapitalizationType = config.autoCapitalization
        textField.textContentType = config.textContentType
        textField.isUserInteractionEnabled = !config.isReadOnly
        textField.textAlignment = config.textAlignment
        if let font = config.textFont { textField.font = font }
        if let color = config.textColor { textField.textColor = color }

        // Secure entry
        isPasswordVisible = false
        textField.isSecureTextEntry = config.isSecureTextEntry
        toggleButton.isHidden = !config.isSecureTextEntry
        updateToggleButtonIcon()

        // Prefix & accessory
        prefixLabel.text = config.prefixText
        prefixLabel.isHidden = config.prefixText == nil

        if let image = config.accessoryImage {
            accessoryImageView.image = image
            accessoryImageView.isHidden = false
        } else {
            accessoryImageView.isHidden = true
        }

        // Card style
        applyCardStyle(
            enabled: model.useCardStyle,
            style: model.cardStyle,
            cornerRadius: model.cardCornerRadius,
            borderColor: model.cardBorderColor,
            shadowColor: model.cardShadowColor
        )

        // Error
        setError(model.validationError)
    }

    func setError(_ error: String?) {
        errorLabel.text = error
        errorLabel.isHidden = error == nil
    }

    // MARK: - Actions
    @objc private func textDidChange() {
        guard var model = model else { return }
        let text = textField.text ?? ""
        model.text = text
        model.onTextChanged?(text)
        onTextChanged?(text)

        var updatedModel = model
        _ = updatedModel.validate()
        setError(updatedModel.validationError)
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        updateToggleButtonIcon()

        // Fix caret bug
        let temp = textField.text
        textField.text = nil
        textField.text = temp
    }

    private func updateToggleButtonIcon() {
        let icon = isPasswordVisible ? "eye.slash.fill" : "eye.fill"
        toggleButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    private func applyCardStyle(
        enabled: Bool,
        style: AppCardStyle,
        cornerRadius: CGFloat,
        borderColor: UIColor,
        shadowColor: UIColor
    ) {
        cardContainerView.layer.cornerRadius = enabled ? cornerRadius : 0
        cardContainerView.backgroundColor = enabled ? .systemBackground : .clear
        cardContainerView.layer.masksToBounds = style == .border

        switch style {
        case .border:
            cardContainerView.layer.borderWidth = 1
            cardContainerView.layer.borderColor = borderColor.cgColor
            cardContainerView.layer.shadowOpacity = 0
        case .shadow:
            cardContainerView.layer.borderWidth = 0
            cardContainerView.layer.shadowColor = shadowColor.cgColor
            cardContainerView.layer.shadowOpacity = 0.1
            cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardContainerView.layer.shadowRadius = 4
            cardContainerView.layer.masksToBounds = false
        case .borderAndShadow:
            cardContainerView.layer.borderWidth = 1
            cardContainerView.layer.borderColor = borderColor.cgColor
            cardContainerView.layer.shadowColor = shadowColor.cgColor
            cardContainerView.layer.shadowOpacity = 0.1
            cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardContainerView.layer.shadowRadius = 4
            cardContainerView.layer.masksToBounds = false
        case .none:
            cardContainerView.layer.borderWidth = 0
            cardContainerView.layer.shadowOpacity = 0
        }
    }
}
