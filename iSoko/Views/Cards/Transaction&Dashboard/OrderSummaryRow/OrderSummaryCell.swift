//
//  OrderSummaryCell.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

// MARK: - OrderSummaryCell

public final class OrderSummaryCell: UITableViewCell {
    private let containerView = UIView()
    
    private let topRowStack = UIStackView()
    private let orderTitleLabel = UILabel()
    private let amountLabel = UILabel()
    
    private let subtitleRowStack = UIStackView()
    private let dateAndCountLabel = UILabel()
    private let statusLabel = PaddingLabel()
    
    private let dividerView = UIView()
    
    private let itemsStack = UIStackView()
    
    private var itemRows: [UIStackView] = []
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.backgroundColor = .systemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        
        // Top row setup
        topRowStack.axis = .horizontal
        topRowStack.alignment = .center
        topRowStack.distribution = .fill
        topRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        orderTitleLabel.font = .preferredFont(forTextStyle: .headline)
        orderTitleLabel.textColor = .label
        
        amountLabel.font = .preferredFont(forTextStyle: .headline)
        amountLabel.textColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        topRowStack.addArrangedSubview(orderTitleLabel)
        topRowStack.addArrangedSubview(amountLabel)
        
        // Subtitle row setup
        subtitleRowStack.axis = .horizontal
        subtitleRowStack.alignment = .center
        subtitleRowStack.distribution = .fill
        subtitleRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        dateAndCountLabel.font = .preferredFont(forTextStyle: .subheadline)
        dateAndCountLabel.textColor = .secondaryLabel
        
        statusLabel.font = .preferredFont(forTextStyle: .subheadline)
        statusLabel.textColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        statusLabel.backgroundColor = UIColor(red: 0.85, green: 1, blue: 0.85, alpha: 1)
        statusLabel.layer.cornerRadius = 12
        statusLabel.layer.masksToBounds = true
        statusLabel.textAlignment = .center
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        statusLabel.paddingLeft = 10
        statusLabel.paddingRight = 10
        statusLabel.paddingTop = 4
        statusLabel.paddingBottom = 4
        
        subtitleRowStack.addArrangedSubview(dateAndCountLabel)
        subtitleRowStack.addArrangedSubview(statusLabel)
        
        // Divider
        dividerView.backgroundColor = UIColor.systemGray4
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Items stack
        itemsStack.axis = .vertical
        itemsStack.spacing = 6
        itemsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all subviews to container
        containerView.addSubview(topRowStack)
        containerView.addSubview(subtitleRowStack)
        containerView.addSubview(dividerView)
        containerView.addSubview(itemsStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            topRowStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            topRowStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            topRowStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            subtitleRowStack.topAnchor.constraint(equalTo: topRowStack.bottomAnchor, constant: 4),
            subtitleRowStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            subtitleRowStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dividerView.topAnchor.constraint(equalTo: subtitleRowStack.bottomAnchor, constant: 8),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            itemsStack.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
            itemsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            itemsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            itemsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    public func configure(with config: OrderSummaryCellConfig) {
        orderTitleLabel.text = config.orderTitle
        orderTitleLabel.font = config.orderTitleFont
        orderTitleLabel.textColor = config.orderTitleColor
        
        amountLabel.text = config.amount
        amountLabel.font = config.amountFont
        amountLabel.textColor = config.amountColor
        
        dateAndCountLabel.text = "\(config.dateString) • \(config.itemCountString)"
        dateAndCountLabel.font = config.subtitleFont
        dateAndCountLabel.textColor = config.subtitleColor
        
        statusLabel.text = config.statusText
        statusLabel.font = config.subtitleFont
        statusLabel.textColor = config.statusTextColor
        statusLabel.backgroundColor = config.statusBackgroundColor
        statusLabel.layer.cornerRadius = config.statusCornerRadius
        
        // Clear old item rows
        itemsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for item in config.items {
            let row = UIStackView()
            row.axis = .horizontal
            row.alignment = .center
            row.distribution = .fill
            row.translatesAutoresizingMaskIntoConstraints = false
            
            let itemLabel = UILabel()
            itemLabel.font = config.itemFont
            itemLabel.text = "\(item.quantity)X \(item.name)"
            itemLabel.textColor = .label
            
            let amountLabel = UILabel()
            amountLabel.font = config.itemAmountFont
            amountLabel.text = item.amount
            amountLabel.textColor = .label
            amountLabel.textAlignment = .right
            amountLabel.setContentHuggingPriority(.required, for: .horizontal)
            amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            row.addArrangedSubview(itemLabel)
            row.addArrangedSubview(amountLabel)
            
            itemsStack.addArrangedSubview(row)
        }
    }
}
