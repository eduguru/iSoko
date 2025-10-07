//
//  PhoneDropDownFormCell.swift
//  
//
//  Created by Edwin Weru on 07/10/2025.
//

import UIKit
import UtilsKit

final class PhoneDropDownFormCell: UITableViewCell {

    // MARK: - UI Components

    private let containerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let cardContainerView = UIView()
    private let stackView = UIStackView()
    private let dropdownButton = UIButton(type: .system)
    private let textField = UITextField()
    private let errorLabel = UILabel()

    // MARK: - Public API

    var onPhoneChanged: ((String) -> Void)?
    var onCountryTapped: (() -> Void)?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        selectionStyle = .none

        // MARK: Container Stack
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

        // MARK: Title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.isHidden = true
        containerStackView.addArrangedSubview(titleLabel)

        // MARK: Card Container View
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.layer.cornerRadius = 8
        cardContainerView.layer.borderWidth = 1
        cardContainerView.layer.borderColor = UIColor.separator.cgColor
        cardContainerView.backgroundColor = .systemBackground
        containerStackView.addArrangedSubview(cardContainerView)

        // MARK: Stack View inside Card
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.addSubview(stackView)

        dropdownButton.setTitle("+254 🇰🇪 ▾", for: .normal)
        dropdownButton.titleLabel?.font = .systemFont(ofSize: 16)
        dropdownButton.setContentHuggingPriority(.required, for: .horizontal)
        dropdownButton.addTarget(self, action: #selector(didTapCountryCode), for: .touchUpInside)

        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = .phonePad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        stackView.addArrangedSubview(dropdownButton)
        stackView.addArrangedSubview(textField)

        // MARK: Error Label
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.addSubview(errorLabel)

        // MARK: Constraints inside Card
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),

            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            errorLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            errorLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configuration

    func configure(with model: PhoneDropDownModel) {
        titleLabel.text = model.titleText
        titleLabel.isHidden = model.titleText == nil

        let flag = CountryHelper.flag(for: model.selectedCountry.id)
        dropdownButton.setTitle("\(model.selectedCountry.phoneCode) \(flag) ▾", for: .normal)

        textField.text = model.phoneNumber
        textField.placeholder = model.placeholder

        setError(model.validationError)
        applyCardStyle(model: model)
    }

    func setError(_ error: String?) {
        errorLabel.text = error
        errorLabel.isHidden = error == nil
    }

    private func applyCardStyle(model: PhoneDropDownModel) {
        cardContainerView.layer.cornerRadius = model.cardCornerRadius
        cardContainerView.layer.borderColor = model.cardBorderColor.cgColor
    }

    // MARK: - Actions

    @objc private func textDidChange() {
        onPhoneChanged?(textField.text ?? "")
    }

    @objc private func didTapCountryCode() {
        onCountryTapped?()
    }
}
