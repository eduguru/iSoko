//
//  SimpleInputFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

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

        // Stack for vertical layout
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

        // Title label
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.isHidden = true

        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(cardContainerView)

        // Card content
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Inner stack
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Prefix
        prefixLabel.font = .systemFont(ofSize: 16)
        prefixLabel.textColor = .darkGray
        prefixLabel.setContentHuggingPriority(.required, for: .horizontal)

        // Text field
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Error label
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // Accessory image
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.tintColor = .gray
        accessoryImageView.setContentHuggingPriority(.required, for: .horizontal)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        accessoryImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Toggle button
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        toggleButton.isHidden = true
        toggleButton.setContentHuggingPriority(.required, for: .horizontal)

        // Add views
        stackView.addArrangedSubview(prefixLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(toggleButton)
        stackView.addArrangedSubview(accessoryImageView)

        cardContainerView.addSubview(stackView)
        cardContainerView.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),

            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Configuration

    func configure(with model: SimpleInputModel) {
        self.model = model
        let config = model.config

        // Title
        if let title = model.titleText {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        // Text field
        textField.text = model.text
        textField.placeholder = config.placeholder
        textField.keyboardType = config.keyboardType
        textField.returnKeyType = config.returnKeyType
        textField.autocapitalizationType = config.autoCapitalization
        textField.textContentType = config.textContentType
        textField.isUserInteractionEnabled = !config.isReadOnly

        // Secure entry
        isPasswordVisible = false
        textField.isSecureTextEntry = config.isSecureTextEntry
        toggleButton.isHidden = !config.isSecureTextEntry
        updateToggleButtonIcon()

        // Prefix label
        prefixLabel.text = config.prefixText
        prefixLabel.isHidden = config.prefixText == nil

        // Accessory image
        if let image = config.accessoryImage {
            accessoryImageView.image = image
            accessoryImageView.isHidden = false
        } else {
            accessoryImageView.isHidden = true
        }

        // Error display
        setError(model.validationError)

        // Card style
        applyCardStyle(
            enabled: model.useCardStyle,
            style: model.cardStyle,
            cornerRadius: model.cardCornerRadius,
            borderColor: model.cardBorderColor,
            shadowColor: model.cardShadowColor
        )

        // Text change observer
        textField.removeTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func setError(_ error: String?) {
        errorLabel.text = error
        errorLabel.isHidden = (error == nil)
    }

    // MARK: - Actions

    @objc private func textDidChange() {
        guard var model = model else { return }
        let text = textField.text ?? ""

        model.text = text
        model.onTextChanged?(text)
        onTextChanged?(text)

        // Optionally re-validate after change
        var updatedModel = model
        _ = updatedModel.validate()
        setError(updatedModel.validationError)
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        updateToggleButtonIcon()

        // Fix caret position bug
        let currentText = textField.text
        textField.text = nil
        textField.text = currentText
    }

    private func updateToggleButtonIcon() {
        let iconName = isPasswordVisible ? "eye.slash.fill" : "eye.fill"
        toggleButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    private func applyCardStyle(
        enabled: Bool,
        style: CardStyle,
        cornerRadius: CGFloat,
        borderColor: UIColor,
        shadowColor: UIColor
    ) {
        if enabled {
            cardContainerView.layer.cornerRadius = cornerRadius
            cardContainerView.backgroundColor = .systemBackground

            switch style {
            case .border:
                cardContainerView.layer.borderWidth = 1
                cardContainerView.layer.borderColor = borderColor.cgColor
                cardContainerView.layer.shadowOpacity = 0
            case .shadow:
                cardContainerView.layer.borderWidth = 0
                cardContainerView.layer.borderColor = nil
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
                cardContainerView.layer.borderColor = nil
                cardContainerView.layer.shadowOpacity = 0
                cardContainerView.layer.shadowColor = nil
                cardContainerView.layer.shadowOffset = .zero
            }
        } else {
            cardContainerView.layer.cornerRadius = 0
            cardContainerView.layer.borderWidth = 0
            cardContainerView.layer.shadowOpacity = 0
        }
    }
}
