//
//  DividerWithTextFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import DesignSystemKit

public final class DividerWithTextFormCell: UITableViewCell {
    private let leftLine = CAShapeLayer()
    private let rightLine = CAShapeLayer()
    private let label = UILabel()

    private var characterCount: Int?

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

        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .gray
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        leftLine.strokeColor = UIColor.gray.cgColor
        leftLine.lineWidth = 1
        leftLine.lineDashPattern = [4, 4]

        rightLine.strokeColor = UIColor.gray.cgColor
        rightLine.lineWidth = 1
        rightLine.lineDashPattern = [4, 4]

        contentView.layer.addSublayer(leftLine)
        contentView.layer.addSublayer(rightLine)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -32),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    public func configure(text: String?, characterCount: Int?) {
        label.text = text
        label.isHidden = text?.isEmpty ?? true
        self.characterCount = characterCount
        setNeedsLayout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let centerY = contentView.bounds.midY
        let contentWidth = contentView.bounds.width
        let sidePadding: CGFloat = 16

        let labelVisible = !(label.text?.isEmpty ?? true)

        if labelVisible {
            let labelWidth = label.intrinsicContentSize.width
            let spacing: CGFloat = 8

            var lineLength: CGFloat
            if let count = characterCount {
                // Estimate line length based on monospaced character width
                let charWidth = label.font.width(of: "W") // estimate
                lineLength = CGFloat(count) * charWidth
            } else {
                // Use available space minus label + spacing
                let available = (contentWidth - labelWidth - spacing * 2) / 2
                lineLength = max(0, available - sidePadding)
            }

            // Left line
            let leftStartX = sidePadding
            let leftEndX = min(leftStartX + lineLength, (contentWidth - labelWidth) / 2 - spacing)

            let leftPath = UIBezierPath()
            leftPath.move(to: CGPoint(x: leftStartX, y: centerY))
            leftPath.addLine(to: CGPoint(x: leftEndX, y: centerY))
            leftLine.path = leftPath.cgPath

            // Right line
            let rightEndX = contentWidth - sidePadding
            let rightStartX = max(rightEndX - lineLength, (contentWidth + labelWidth) / 2 + spacing)

            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: rightStartX, y: centerY))
            rightPath.addLine(to: CGPoint(x: rightEndX, y: centerY))
            rightLine.path = rightPath.cgPath

        } else {
            // No text → full width divider
            let fullLine = UIBezierPath()
            fullLine.move(to: CGPoint(x: sidePadding, y: centerY))
            fullLine.addLine(to: CGPoint(x: contentWidth - sidePadding, y: centerY))
            leftLine.path = fullLine.cgPath
            rightLine.path = nil
        }
    }
}

extension UIFont {
    func width(of text: String) -> CGFloat {
        (text as NSString).size(withAttributes: [.font: self]).width
    }
}
