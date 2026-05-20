//
//  LongDescriptionFormCell.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit


final class LongInputDescriptionFormCell: UITableViewCell, UITextViewDelegate {

    // UI Elements
    private var textView: UITextView!
    private var prefixLabel: UILabel!
    private var errorLabel: UILabel!

    private let containerView = UIView()

    var onTextChanged: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textView = UITextView()
        prefixLabel = UILabel()
        errorLabel = UILabel()

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // MARK: Prefix
        prefixLabel.font = .systemFont(ofSize: 14, weight: .medium)

        // MARK: Container (FIX for ugly full white block)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.addSubview(prefixLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(errorLabel)

        prefixLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: TextView FIX (padding + remove white bg)
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear

        // 👇 THIS IS THE IMPORTANT FIX (internal padding)
        textView.textContainerInset = UIEdgeInsets(
            top: 10,
            left: 8,
            bottom: 10,
            right: 8
        )

        containerView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Prefix
            prefixLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            prefixLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            prefixLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Container
            containerView.topAnchor.constraint(equalTo: prefixLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // TextView inside container
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 100),

            // Error
            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        // MARK: Error styling
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
    }

    func configure(with model: LongInputDescriptionModel) {

        textView.text = model.text

        if let prefix = model.titleText {
            prefixLabel.text = prefix
        }

        textView.isEditable = !model.config.isReadOnly
        textView.isScrollEnabled = model.config.isScrollable

        if let errorMessage = model.validationError {
            errorLabel.text = errorMessage
        } else {
            errorLabel.text = ""
        }
    }

    func setError(_ errorMessage: String?) {
        errorLabel.text = errorMessage
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
}
