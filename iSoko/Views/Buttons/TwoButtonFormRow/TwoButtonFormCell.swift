//
//  TwoButtonFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import UIKit
import DesignSystemKit

public final class TwoButtonFormCell: UITableViewCell {

    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    public func configure(with button1Model: ButtonFormModel, button2Model: ButtonFormModel, layout: MultiButtonFormModel.Layout) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch layout {
        case .vertical(let spacing):
            stackView.axis = .vertical
            stackView.spacing = spacing
            stackView.distribution = .fill

        case .horizontal(let spacing, let distribution):
            stackView.axis = .horizontal
            stackView.spacing = spacing
            stackView.distribution = distribution
        }

        // Create and add the first button
        let button1 = StyledButton(style: button1Model.style, size: button1Model.size, fontStyle: button1Model.fontStyle)
        button1.setTitle(button1Model.title, for: .normal)
        button1.enableHaptics = button1Model.hapticsEnabled
        button1.isEnabled = button1Model.isEnabled
        button1.setLoading(button1Model.isLoading)

        if let icon = button1Model.icon {
            button1.setImage(icon, for: .normal)
        }

        // Reset actions before adding a new one
        button1.removeTarget(nil, action: nil, for: .allEvents)
        if let action = button1Model.action {
            button1.debounceInterval = 0.5
            button1.addDebouncedAction(action)
        }

        // Create and add the second button
        let button2 = StyledButton(style: button2Model.style, size: button2Model.size, fontStyle: button2Model.fontStyle)
        button2.setTitle(button2Model.title, for: .normal)
        button2.enableHaptics = button2Model.hapticsEnabled
        button2.isEnabled = button2Model.isEnabled
        button2.setLoading(button2Model.isLoading)

        if let icon = button2Model.icon {
            button2.setImage(icon, for: .normal)
        }

        // Reset actions before adding a new one
        button2.removeTarget(nil, action: nil, for: .allEvents)
        if let action = button2Model.action {
            button2.debounceInterval = 0.5
            button2.addDebouncedAction(action)
        }

        // Add buttons to the stack view
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
    }
}
