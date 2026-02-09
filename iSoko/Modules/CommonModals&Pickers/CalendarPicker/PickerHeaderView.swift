//
//  PickerHeaderView.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

final class PickerHeaderView: UIView {

    let cancelButton = UIButton(type: .system)
    let confirmButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        cancelButton.setTitle("Cancel", for: .normal)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.isEnabled = false

        let spacer = UIView()
        let stack = UIStackView(arrangedSubviews: [cancelButton, spacer, confirmButton])
        stack.axis = .horizontal
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}
