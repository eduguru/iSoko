//
//  SpacerFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit

public final class SpacerFormCell: UITableViewCell {
    public static let height: CGFloat = 24

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
    }
}
