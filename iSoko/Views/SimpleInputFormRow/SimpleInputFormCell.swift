//
//  SimpleInputFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 07/08/2025.
//

import UIKit

final class SimpleInputFormCell: UITableViewCell {

    private let stackView = UIStackView()
    private let prefixLabel = UILabel()
    private let textField = UITextField()
    private let errorLabel = UILabel()
    private let accessoryImageView = UIImageView()
    private let toggleButton = UIButton(type: .system)

    private var model: SimpleInputModel?
    private var isPasswordVisible = false

    // 👇 Exposed callback for external usage (e.g. in FormRow)
    var onTextChanged: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        // Stack View
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Prefix Label
        prefixLabel.font = .systemFont(ofSize: 16)
        prefixLabel.textColor = .darkGray
        prefixLabel.setContentHuggingPriority(.required, for: .horizontal)

        // TextField
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Error Label
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // Accessory Image View
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.tintColor = .gray
        accessoryImageView.setContentHuggingPriority(.required, for: .horizontal)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        accessoryImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Toggle Button
        toggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        toggleButton.isHidden = true
        toggleButton.setContentHuggingPriority(.required, for: .horizontal)

        // Layout
        contentView.addSubview(stackView)
        contentView.addSubview(errorLabel)

        stackView.addArrangedSubview(prefixLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(toggleButton)
        stackView.addArrangedSubview(accessoryImageView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Public Configuration

    func configure(with model: SimpleInputModel) {
        self.model = model

        let config = model.config

        // TextField setup
        textField.text = model.text
        textField.placeholder = config.placeholder
        textField.keyboardType = config.keyboardType
        textField.returnKeyType = config.returnKeyType
        textField.autocapitalizationType = config.autoCapitalization
        textField.textContentType = config.textContentType
        textField.isUserInteractionEnabled = !config.isReadOnly

        // Secure entry handling
        isPasswordVisible = false
        textField.isSecureTextEntry = config.isSecureTextEntry
        toggleButton.isHidden = !config.isSecureTextEntry
        updateToggleButtonIcon()

        // Prefix and accessory
        prefixLabel.text = config.prefixText
        prefixLabel.isHidden = config.prefixText == nil

        if let image = config.accessoryImage {
            accessoryImageView.image = image
            accessoryImageView.isHidden = false
        } else {
            accessoryImageView.isHidden = true
        }

        // Error display
        setError(model.validationError)

        // Observe text change
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
        model.onTextChanged?(text) // Notify model
        onTextChanged?(text)       // Notify form row
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        updateToggleButtonIcon()

        // Fix caret position bug after toggling secure text
        let currentText = textField.text
        textField.text = nil
        textField.text = currentText
    }

    private func updateToggleButtonIcon() {
        let iconName = isPasswordVisible ? "eye.slash.fill" : "eye.fill"
        toggleButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
}
