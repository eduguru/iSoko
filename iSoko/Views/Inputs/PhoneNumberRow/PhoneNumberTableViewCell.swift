//
//  PhoneNumberTableViewCell.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import UIKit
import PhoneNumberKit

class PhoneNumberTableViewCell: UITableViewCell {

    private var cardView: UIView!
    private var phoneNumberTextField: PhoneNumberTextField!
    private var phoneNumberModel: PhoneNumberModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCardView()
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardView()
        setupTextField()
    }

    private func setupCardView() {
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }

    private func setupTextField() {
        phoneNumberTextField = PhoneNumberTextField()
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(phoneNumberTextField)

        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            phoneNumberTextField.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
        ])

        phoneNumberTextField.tintColor = .black
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.textContentType = .telephoneNumber
        phoneNumberTextField.keyboardType = .phonePad

        phoneNumberTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }

    func configure(with model: PhoneNumberModel) {
        self.phoneNumberModel = model

        phoneNumberTextField.placeholder = model.placeholder
        phoneNumberTextField.defaultRegion = model.defaultRegion
        phoneNumberTextField.withFlag = model.withFlag
        phoneNumberTextField.text = model.phoneNumber

        applyCardStyle()
        cardView.isHidden = !model.useCardStyle
    }

    private func applyCardStyle() {
        guard phoneNumberModel.useCardStyle else {
            cardView.layer.cornerRadius = 0
            cardView.layer.borderWidth = 0
            cardView.layer.shadowOpacity = 0
            return
        }

        cardView.layer.cornerRadius = phoneNumberModel.cardCornerRadius
        cardView.layer.masksToBounds = false

        switch phoneNumberModel.cardStyle {
        case .none:
            cardView.layer.borderWidth = 0
            cardView.layer.shadowOpacity = 0
        case .border:
            cardView.layer.borderWidth = 1
            cardView.layer.borderColor = phoneNumberModel.cardBorderColor.cgColor
            cardView.layer.shadowOpacity = 0
        case .shadow:
            cardView.layer.borderWidth = 0
            cardView.layer.shadowColor = phoneNumberModel.cardShadowColor.cgColor
            cardView.layer.shadowOpacity = 0.3
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 4
        case .borderAndShadow:
            cardView.layer.borderWidth = 1
            cardView.layer.borderColor = phoneNumberModel.cardBorderColor.cgColor
            cardView.layer.shadowColor = phoneNumberModel.cardShadowColor.cgColor
            cardView.layer.shadowOpacity = 0.3
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 4
        }
    }

    @objc private func textChanged(_ textField: UITextField) {
        phoneNumberModel.phoneNumber = textField.text
    }

    // Optional: toggle card visibility manually if needed
    func toggleCard(visible: Bool) {
        cardView.isHidden = !visible
    }
}
