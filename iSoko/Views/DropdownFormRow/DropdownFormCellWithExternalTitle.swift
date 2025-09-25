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
    
    private var onTapCallback: (() -> Void)?
    
    private let verticalStack = UIStackView()
    private let valueStack = UIStackView()
    
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
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        valueStack.axis = .horizontal
        valueStack.spacing = 8
        valueStack.alignment = .center
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(valueStack)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        valueStack.addArrangedSubview(leftImageView)
        valueStack.addArrangedSubview(valueLabel)
        valueStack.addArrangedSubview(rightImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            verticalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            verticalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            verticalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            leftImageView.widthAnchor.constraint(equalToConstant: 24),
            leftImageView.heightAnchor.constraint(equalToConstant: 24),
            
            rightImageView.widthAnchor.constraint(equalToConstant: 16),
            rightImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    public func configure(with config: DropdownFormConfig) {
        onTapCallback = config.onTap
        
        if config.showTitle, let title = config.title {
            titleLabel.isHidden = false
            titleLabel.text = config.showAsterisk ? "\(title) *" : title
            titleLabel.font = config.titleFont
            titleLabel.textColor = config.titleColor
        } else {
            titleLabel.isHidden = true
        }
        
        if let value = config.value, !value.isEmpty {
            valueLabel.text = value
            valueLabel.textColor = .label
        } else {
            valueLabel.text = config.placeholder
            valueLabel.textColor = .secondaryLabel
        }
        
        if let subtitle = config.subtitle, !subtitle.isEmpty {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
            subtitleLabel.font = config.subtitleFont
            subtitleLabel.textColor = config.subtitleColor
        } else {
            subtitleLabel.isHidden = true
        }
        
        if let image = config.leftImage {
            leftImageView.isHidden = false
            leftImageView.image = image
        } else {
            leftImageView.isHidden = true
        }
        
        if let image = config.rightImage {
            rightImageView.isHidden = false
            rightImageView.image = image
        } else {
            rightImageView.isHidden = true
        }
        
        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor.cgColor
            containerView.backgroundColor = config.cardBackgroundColor
        } else {
            containerView.layer.cornerRadius = 0
            containerView.layer.borderWidth = 0
            containerView.backgroundColor = .clear
        }
        
        containerView.alpha = config.isEnabled ? 1.0 : 0.5
        isUserInteractionEnabled = config.isEnabled
    }

    @objc private func handleTap() {
        onTapCallback?()
    }
}
