//
//  SegmentedControlCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit

public class SegmentedControlCell: UITableViewCell {
    
    public let titleLabel = UILabel()
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        onValueChanged?(sender.selectedSegmentIndex)
    }

    func configure(with model: SegmentedFormModel) {
        titleLabel.text = model.title
        segmentedControl.removeAllSegments()

        for (index, title) in model.segments.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = model.selectedIndex

        // Apply styling
        contentView.backgroundColor = model.backgroundColor
        titleLabel.textColor = model.titleTextColor

        segmentedControl.tintColor = model.tintColor
        segmentedControl.selectedSegmentTintColor = model.selectedSegmentTintColor

        // Style segment text (only works on iOS 13+ with setTitleTextAttributes)
        if let textColor = model.segmentTextColor {
            segmentedControl.setTitleTextAttributes([.foregroundColor: textColor], for: .normal)
        }
        if let selectedTextColor = model.selectedSegmentTextColor {
            segmentedControl.setTitleTextAttributes([.foregroundColor: selectedTextColor], for: .selected)
        }
    }
}
