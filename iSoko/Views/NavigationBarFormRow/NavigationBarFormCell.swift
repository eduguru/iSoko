//
//  NavigationBarFormCell.swift
//  
//
//  Created by Edwin Weru on 13/11/2025.
//

import UIKit

public final class NavigationBarFormCell: UITableViewCell {
    
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    
    // Define the configuration model
    private var navBarConfig: NavigationBarConfig?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Configure the buttons
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            // Left button constraints
            leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Right button constraints
            rightButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc private func leftButtonTapped() {
        navBarConfig?.leftButton?.action?()
    }
    
    @objc private func rightButtonTapped() {
        navBarConfig?.rightButton?.action?()
    }
    
    // Method to configure the navigation bar cell with the model
    public func configure(with config: NavigationBarConfig) {
        self.navBarConfig = config
        
        // Configure left button
        if let leftButtonConfig = config.leftButton {
            leftButton.setTitle(leftButtonConfig.title, for: .normal)
            leftButton.setImage(leftButtonConfig.image, for: .normal)
            
            // Apply the text color if provided
            if let textColor = leftButtonConfig.textColor {
                leftButton.setTitleColor(textColor, for: .normal)
            }
            
            // Apply the image color if provided
            if let imageColor = leftButtonConfig.imageColor, let image = leftButtonConfig.image {
                leftButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                leftButton.tintColor = imageColor
            }
        }
        
        // Configure right button
        if let rightButtonConfig = config.rightButton {
            rightButton.setTitle(rightButtonConfig.title, for: .normal)
            rightButton.setImage(rightButtonConfig.image, for: .normal)
            
            // Apply the text color if provided
            if let textColor = rightButtonConfig.textColor {
                rightButton.setTitleColor(textColor, for: .normal)
            }
            
            // Apply the image color if provided
            if let imageColor = rightButtonConfig.imageColor, let image = rightButtonConfig.image {
                rightButton.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                rightButton.tintColor = imageColor
            }
        }
    }
}
