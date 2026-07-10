//
//  CheckRowCell.swift
//  
//
//  Created by Edwin Weru on 10/07/2026.
//

import UIKit

public final class CheckRowCell: UITableViewCell {

    private let checkbox = UIButton(type: .custom)
    private let titleLabel = UILabel()

    private var config: CheckRowConfig?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        config = nil
        checkbox.isSelected = false
        titleLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        checkbox.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkbox.adjustsImageWhenHighlighted = false
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [checkbox, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    public func configure(with config: CheckRowConfig) {
        self.config = config

        checkbox.isSelected = config.isChecked
        checkbox.tintColor = config.checkboxTintColor

        titleLabel.text = config.title
        titleLabel.textColor = config.textColor
        titleLabel.font = config.font

        applyCardStyleIfNeeded(config)
    }

    private func applyCardStyleIfNeeded(_ config: CheckRowConfig) {
        if config.useCardStyle {
            contentView.backgroundColor = config.cardBackgroundColor
            contentView.layer.cornerRadius = 12
            contentView.layer.masksToBounds = true
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.cornerRadius = 0
            contentView.layer.masksToBounds = false
        }
    }

    @objc
    private func toggleCheckbox() {
        checkbox.isSelected.toggle()
        config?.onToggle?(checkbox.isSelected)
    }
}
