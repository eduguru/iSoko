//
//  DividerFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public final class DividerFormCell: UITableViewCell {
    private let divider = UIView()

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

        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
