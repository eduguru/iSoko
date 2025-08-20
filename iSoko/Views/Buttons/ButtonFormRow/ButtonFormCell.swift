//
//  ButtonFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import DesignSystemKit

public final class ButtonFormCell: UITableViewCell {

    private let button = StyledButton()

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

        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    public func configure(with model: ButtonFormModel) {
        button.setTitle(model.title, for: .normal)
        button.style = model.style
        button.size = model.size
        button.fontStyle = model.fontStyle
        button.enableHaptics = model.hapticsEnabled

        if let icon = model.icon {
            button.setImage(icon, for: .normal)
        }

        // Reset actions before adding a new one
        button.removeTarget(nil, action: nil, for: .allEvents)
        if let action = model.action {
            button.debounceInterval = 0.5
            button.addDebouncedAction(action)
        }
    }
}
