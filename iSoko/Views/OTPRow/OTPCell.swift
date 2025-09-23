//
//  OTPCell.swift
//  
//
//  Created by Edwin Weru on 23/09/2025.
//

import UIKit

final class OTPTextField: UITextField {
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        super.deleteBackward()
        onDeleteBackward?()
    }
}


// MARK: - Cell
import UIKit

public final class OTPRowCell: UITableViewCell, UITextFieldDelegate {
    private var stackView = UIStackView()
    private var textFields: [OTPTextField] = []
    private var timerLabel = UILabel()
    private var sentLabel = UILabel()
    private var resendButton = UIButton(type: .system)

    private var config: OTPRowConfig?
    private var timer: Timer?
    private var secondsRemaining: Int = 0

    // MARK: - Init

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

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        sentLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        sentLabel.textColor = .secondaryLabel
        sentLabel.textAlignment = .center
        sentLabel.numberOfLines = 0

        timerLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        timerLabel.textColor = .secondaryLabel
        timerLabel.textAlignment = .center
        timerLabel.isHidden = true

        resendButton.setTitle("Resend", for: .normal)
        resendButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        resendButton.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        resendButton.isHidden = true

        let footerStack = UIStackView(arrangedSubviews: [timerLabel, resendButton])
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 8
        footerStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [sentLabel, stackView, footerStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    public func configure(with config: OTPRowConfig) {
        self.config = config
        sentLabel.text = config.sentMessage

        setupTextFields(count: config.numberOfDigits, keyboardType: config.keyboardType)

        if config.showResendTimer {
            startResendTimer(duration: config.resendDuration)
        } else {
            timerLabel.isHidden = true
            resendButton.isHidden = false
        }
    }

    private func setupTextFields(count: Int, keyboardType: UIKeyboardType) {
        textFields.forEach { $0.removeFromSuperview() }
        textFields.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0..<count {
            let field = OTPTextField()
            field.keyboardType = keyboardType
            field.textAlignment = .center
            field.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .medium)
            field.backgroundColor = .tertiarySystemGroupedBackground
            field.layer.cornerRadius = 8
            field.layer.masksToBounds = true
            field.textContentType = .oneTimeCode
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.tag = index
            field.delegate = self
            field.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)

            field.onDeleteBackward = { [weak self, weak field] in
                guard let self, let tf = field else { return }
                self.handleBackspace(on: tf)
            }

            field.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                field.widthAnchor.constraint(equalToConstant: 40),
                field.heightAnchor.constraint(equalToConstant: 48)
            ])

            stackView.addArrangedSubview(field)
            textFields.append(field)
        }

        textFields.first?.becomeFirstResponder()
    }

    @objc private func textFieldChanged(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }

        let nextIndex = textField.tag + 1
        if nextIndex < textFields.count {
            textFields[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        // Combine all inputs
        let otp = textFields.compactMap { $0.text }.joined()

        let allFilled = otp.count == textFields.count && !otp.contains { $0.isWhitespace }
        if allFilled {
            config?.onOTPComplete?(otp)
        }
    }

    private func handleBackspace(on textField: UITextField) {
        guard let otpField = textField as? OTPTextField,
              let index = textFields.firstIndex(of: otpField) else { return }

        if let text = otpField.text, !text.isEmpty {
            otpField.text = ""
        } else if index > 0 {
            let previous = textFields[index - 1]
            previous.text = ""
            previous.becomeFirstResponder()
        }
    }

    @objc private func resendTapped() {
        config?.onResendTapped?()
        startResendTimer(duration: config?.resendDuration ?? 30)
    }

    private func startResendTimer(duration: Double) {
        secondsRemaining = Int(duration)
        updateTimerLabel()
        resendButton.isHidden = true
        timerLabel.isHidden = false

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        secondsRemaining -= 1
        updateTimerLabel()

        if secondsRemaining <= 0 {
            timer?.invalidate()
            resendButton.isHidden = false
            timerLabel.isHidden = true
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "Resend in \(secondsRemaining)s"
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - UITextFieldDelegate

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }

        if string.count > 1 {
            // Handle paste
            let characters = Array(string)
            for (i, char) in characters.prefix(textFields.count).enumerated() {
                textFields[i].text = String(char)
            }

            let otp = textFields.compactMap { $0.text }.joined()
            let allFilled = otp.count == textFields.count && !otp.contains { $0.isWhitespace }
            if allFilled {
                config?.onOTPComplete?(otp)
            }

            textFields.last?.resignFirstResponder()
            return false
        }

        // Allow only one character per field
        if (currentText + string).count > 1 {
            return false
        }

        return true
    }
}
