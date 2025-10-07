//
//  SearchFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public final class SearchFormCell: UITableViewCell, UITextFieldDelegate {

    private let container = UIView()
    private let textField = UITextField()

    // Icon buttons
    private let leftIconButton = UIButton(type: .system)
    private let rightSearchButton = UIButton(type: .system)
    private let rightFilterButton = UIButton(type: .system)

    // Stack view to hold right-side buttons (inside container)
    private let rightIconStackView = UIStackView()

    // Filter icon outside
    private let externalFilterButton = UIButton(type: .system)

    // Constraints
    private var textFieldLeadingToLeftButton: NSLayoutConstraint!
    private var textFieldLeadingToContainer: NSLayoutConstraint!
    private var textFieldTrailingToRightStack: NSLayoutConstraint!
    private var textFieldTrailingToContainer: NSLayoutConstraint!

    private var containerTrailingToContent: NSLayoutConstraint!
    private var containerTrailingWithExternalFilter: NSLayoutConstraint!

    private var model: SearchFormModel?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Container
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .app(.surface)
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        contentView.addSubview(container)

        // TextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        container.addSubview(textField)

        // Left icon
        leftIconButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(leftIconButton)

        // Right icon stack
        rightIconStackView.axis = .horizontal
        rightIconStackView.spacing = 8
        rightIconStackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(rightIconStackView)

        rightSearchButton.translatesAutoresizingMaskIntoConstraints = false
        rightFilterButton.translatesAutoresizingMaskIntoConstraints = false

        rightIconStackView.addArrangedSubview(rightSearchButton)
        rightIconStackView.addArrangedSubview(rightFilterButton)

        // External filter
        externalFilterButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(externalFilterButton)

        // Layout (initial)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            leftIconButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            leftIconButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            leftIconButton.widthAnchor.constraint(equalToConstant: 24),
            leftIconButton.heightAnchor.constraint(equalToConstant: 24),

            rightIconStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            rightIconStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            rightSearchButton.widthAnchor.constraint(equalToConstant: 24),
            rightSearchButton.heightAnchor.constraint(equalToConstant: 24),
            rightFilterButton.widthAnchor.constraint(equalToConstant: 24),
            rightFilterButton.heightAnchor.constraint(equalToConstant: 24),

            externalFilterButton.leadingAnchor.constraint(equalTo: container.trailingAnchor, constant: 8),
            externalFilterButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            externalFilterButton.widthAnchor.constraint(equalToConstant: 24),
            externalFilterButton.heightAnchor.constraint(equalToConstant: 24),
            externalFilterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        // Trailing constraint (not activated here)
        containerTrailingToContent = container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        containerTrailingWithExternalFilter = container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -56)
        containerTrailingToContent.isActive = true

        // TextField adjustable constraints
        textFieldLeadingToLeftButton = textField.leadingAnchor.constraint(equalTo: leftIconButton.trailingAnchor, constant: 8)
        textFieldLeadingToContainer = textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8)
        textFieldTrailingToRightStack = textField.trailingAnchor.constraint(equalTo: rightIconStackView.leadingAnchor, constant: -8)
        textFieldTrailingToContainer = textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)

        textField.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

    public func configure(with model: SearchFormModel) {
        self.model = model

        // Placeholder
        if let attributed = model.attributedPlaceholder {
            textField.attributedPlaceholder = attributed
        } else {
            textField.placeholder = model.placeholder
        }

        textField.text = model.text
        textField.keyboardType = model.keyboardType

        // Reset visibility and constraints
        leftIconButton.isHidden = true
        rightSearchButton.isHidden = true
        rightFilterButton.isHidden = true
        externalFilterButton.isHidden = true

        leftIconButton.removeTarget(nil, action: nil, for: .allEvents)
        rightSearchButton.removeTarget(nil, action: nil, for: .allEvents)
        rightFilterButton.removeTarget(nil, action: nil, for: .allEvents)
        externalFilterButton.removeTarget(nil, action: nil, for: .allEvents)

        textFieldLeadingToLeftButton.isActive = false
        textFieldLeadingToContainer.isActive = false
        textFieldTrailingToRightStack.isActive = false
        textFieldTrailingToContainer.isActive = false

        // --- Search Icon ---
        if let icon = model.searchIcon {
            switch model.searchIconPlacement {
            case .left:
                leftIconButton.setImage(icon, for: .normal)
                leftIconButton.isHidden = false
                textFieldLeadingToLeftButton.isActive = true
                leftIconButton.addAction(UIAction { [weak self] _ in
                    model.didTapSearchIcon?()
                    self?.textField.becomeFirstResponder()
                }, for: .touchUpInside)
            case .right, .inside:
                rightSearchButton.setImage(icon, for: .normal)
                rightSearchButton.isHidden = false
                textFieldTrailingToRightStack.isActive = true
                rightSearchButton.addAction(UIAction { [weak self] _ in
                    model.didTapSearchIcon?()
                    self?.textField.becomeFirstResponder()
                }, for: .touchUpInside)
            case .outside:
                break
            }
        }

        // --- Filter Icon ---
        if let icon = model.filterIcon {
            switch model.filterIconPlacement {
            case .inside:
                rightFilterButton.setImage(icon, for: .normal)
                rightFilterButton.isHidden = false
                textFieldTrailingToRightStack.isActive = true
                rightFilterButton.addAction(UIAction { _ in
                    model.didTapFilterIcon?()
                }, for: .touchUpInside)
            case .outside:
                externalFilterButton.setImage(icon, for: .normal)
                externalFilterButton.isHidden = false
                textFieldTrailingToContainer.isActive = true
                externalFilterButton.addAction(UIAction { _ in
                    model.didTapFilterIcon?()
                }, for: .touchUpInside)
            default:
                break
            }
        }

        // Fallback constraints
        if !textFieldLeadingToLeftButton.isActive {
            textFieldLeadingToContainer.isActive = true
        }
        if !(textFieldTrailingToRightStack.isActive || textFieldTrailingToContainer.isActive) {
            textFieldTrailingToContainer.isActive = true
        }

        // Handle container trailing
        containerTrailingToContent.isActive = false
        containerTrailingWithExternalFilter.isActive = false
        if model.filterIcon != nil, model.filterIconPlacement == .outside {
            containerTrailingWithExternalFilter.isActive = true
        } else {
            containerTrailingToContent.isActive = true
        }

        layoutIfNeeded()
    }

    // MARK: - TextField Delegate

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        model?.didStartEditing?(textField.text ?? "")
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        model?.didEndEditing?(textField.text ?? "")
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        model?.onTextChanged?(newText)
        return true
    }
}
