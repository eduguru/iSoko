//
//  DropdownFormCellWithExternalTitle.swift
//  
//
//  Created by Edwin Weru on 25/09/2025.
//

import UIKit

public class DropdownFormCellWithExternalTitle: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let containerView = UIView()
    
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    
    private let actionButton = UIButton(type: .system)
    
    private var onTapCallback: (() -> Void)?
    private var onActionTapCallback: (() -> Void)?
    
    private let verticalStack = UIStackView()
    private let valueStack = UIStackView()
    private let horizontalStack = UIStackView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [titleLabel, valueLabel, subtitleLabel].forEach {
            $0.numberOfLines = 0
        }
        
        leftImageView.contentMode = .scaleAspectFit
        rightImageView.contentMode = .scaleAspectFit
        
        // Vertical content stack (inside container)
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Value row
        valueStack.axis = .horizontal
        valueStack.spacing = 8
        valueStack.alignment = .center
        
        // Horizontal wrapper (container + button)
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 8
        horizontalStack.alignment = .fill
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(horizontalStack)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(verticalStack)
        
        horizontalStack.addArrangedSubview(containerView)
        horizontalStack.addArrangedSubview(actionButton)
        
        verticalStack.addArrangedSubview(valueStack)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        valueStack.addArrangedSubview(leftImageView)
        valueStack.addArrangedSubview(valueLabel)
        valueStack.addArrangedSubview(rightImageView)
        
        // Dropdown tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
        
        // Action button setup
        actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        actionButton.tintColor = .app(.primary)
        actionButton.backgroundColor = .secondarySystemBackground
        actionButton.layer.cornerRadius = 10
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(handleActionTap), for: .touchUpInside)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Horizontal stack (container + button)
            horizontalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Inner content
            verticalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            verticalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            verticalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            // Images
            leftImageView.widthAnchor.constraint(equalToConstant: 24),
            leftImageView.heightAnchor.constraint(equalToConstant: 24),
            
            rightImageView.widthAnchor.constraint(equalToConstant: 16),
            rightImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Action button size
            actionButton.widthAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    public func configure(with config: DropdownFormConfig) {
        onTapCallback = config.onTap
        onActionTapCallback = config.onActionTap
        
        // Title
        if config.showTitle, let title = config.title {
            titleLabel.isHidden = false
            titleLabel.text = config.showAsterisk ? "\(title) *" : title
            titleLabel.font = config.titleFont
            titleLabel.textColor = config.titleColor
        } else {
            titleLabel.isHidden = true
        }
        
        // Value / placeholder
        if let value = config.value, !value.isEmpty {
            valueLabel.text = value
            valueLabel.textColor = .label
        } else {
            valueLabel.text = config.placeholder
            valueLabel.textColor = .secondaryLabel
        }
        
        // Subtitle
        if let subtitle = config.subtitle, !subtitle.isEmpty {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
            subtitleLabel.font = config.subtitleFont
            subtitleLabel.textColor = config.subtitleColor
        } else {
            subtitleLabel.isHidden = true
        }
        
        // Left image
        if let image = config.leftImage {
            leftImageView.isHidden = false
            leftImageView.image = image
        } else {
            leftImageView.isHidden = true
        }
        
        // Right image (dropdown arrow)
        if let image = config.rightImage {
            rightImageView.isHidden = false
            rightImageView.image = image
        } else {
            rightImageView.isHidden = true
        }
        
        // Card styling
        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor.cgColor
            containerView.backgroundColor = config.cardBackgroundColor
            
            // Match button style
            actionButton.layer.borderWidth = config.cardBorderWidth
            actionButton.layer.borderColor = config.cardBorderColor.cgColor
        } else {
            containerView.layer.cornerRadius = 0
            containerView.layer.borderWidth = 0
            containerView.backgroundColor = .clear
            
            actionButton.layer.borderWidth = 0
        }
        
        // Action button visibility
        if config.showsActionButton {
            actionButton.isHidden = false
            actionButton.setImage(config.actionImage ?? UIImage(systemName: "plus"), for: .normal)
        } else {
            actionButton.isHidden = true
        }
        
        containerView.alpha = config.isEnabled ? 1.0 : 0.5
        actionButton.alpha = config.isEnabled ? 1.0 : 0.5
        isUserInteractionEnabled = config.isEnabled
    }

    @objc private func handleTap() {
        onTapCallback?()
    }
    
    @objc private func handleActionTap() {
        onActionTapCallback?()
    }
}
