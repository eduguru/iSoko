//
//  MultiButtonFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import DesignSystemKit

public final class MultiButtonFormCell: UITableViewCell {

    private let stackView = UIStackView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    public func configure(with model: MultiButtonFormModel) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        switch model.layout {
        case .vertical(let spacing):
            stackView.axis = .vertical
            stackView.spacing = spacing
            stackView.distribution = .fill
        case .horizontal(let spacing, let distribution):
            stackView.axis = .horizontal
            stackView.spacing = spacing
            stackView.distribution = distribution
        }

        for buttonModel in model.buttons {
            let button = StyledButton(style: buttonModel.style, size: buttonModel.size, fontStyle: buttonModel.fontStyle)
            button.setTitle(buttonModel.title, for: .normal)
            button.enableHaptics = buttonModel.hapticsEnabled
            button.isEnabled = buttonModel.isEnabled
            button.setLoading(buttonModel.isLoading)

            if let icon = buttonModel.icon {
                button.setImage(icon, for: .normal)
            }

            if let action = buttonModel.action {
                button.debounceInterval = 0.5
                button.addDebouncedAction(action)
            }

            stackView.addArrangedSubview(button)
        }
        
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()

    }
}
