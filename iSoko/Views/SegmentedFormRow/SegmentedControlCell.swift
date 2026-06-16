//
//  SegmentedControlCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public final class SegmentedControlCell: UITableViewCell {

    public let segmentedControl = UISegmentedControl()

    var onValueChanged: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Natural height for the segmented control
            segmentedControl.heightAnchor.constraint(equalToConstant: 34)
        ])

        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged(_:)),
            for: .valueChanged
        )
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        onValueChanged?(sender.selectedSegmentIndex)
    }

    public func configure(with model: SegmentedFormModel) {
        segmentedControl.removeAllSegments()

        for (index, title) in model.segments.enumerated() {
            segmentedControl.insertSegment(
                withTitle: title,
                at: index,
                animated: false
            )
        }

        segmentedControl.selectedSegmentIndex = model.selectedIndex

        segmentedControl.selectedSegmentTintColor = model.selectedSegmentTintColor

        if let tintColor = model.tintColor {
            segmentedControl.tintColor = tintColor
        }

        if let textColor = model.segmentTextColor {
            segmentedControl.setTitleTextAttributes(
                [.foregroundColor: textColor],
                for: .normal
            )
        }

        if let selectedTextColor = model.selectedSegmentTextColor {
            segmentedControl.setTitleTextAttributes(
                [.foregroundColor: selectedTextColor],
                for: .selected
            )
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        segmentedControl.removeAllSegments()
        onValueChanged = nil
    }
}
