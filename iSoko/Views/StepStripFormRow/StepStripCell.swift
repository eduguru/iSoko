//
//  StepStripCell.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import UIKit

public final class StepStripCell: UITableViewCell {

    // MARK: - Views
    private let titleLabel = UILabel()
    private let stepStack = UIStackView()

    private var stepViews: [UIView] = []
    private var model: StepStripModel?

    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .secondaryLabel

        stepStack.axis = .horizontal
        stepStack.distribution = .fillEqually
        stepStack.spacing = 6
        stepStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(stepStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            stepStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stepStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stepStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stepStack.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    // MARK: - Configure
    public func configure(with model: StepStripModel) {
        self.model = model

        titleLabel.text = model.title ?? ""
        // titleLabel.text = model.title ?? "Step \(model.currentStep) of \(model.totalSteps)"
        titleLabel.textColor = model.titleColor ?? .secondaryLabel

        // Clear old steps
        stepStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stepViews.removeAll()

        // Build steps
        for i in 1...model.totalSteps {
            let segment = UIView()
            segment.layer.cornerRadius = 3
            segment.clipsToBounds = true

            if i <= model.currentStep {
                segment.backgroundColor = model.activeColor ?? .app(.primary)
            } else {
                segment.backgroundColor = model.inactiveColor ?? UIColor.systemGray4
            }

            stepStack.addArrangedSubview(segment)
            stepViews.append(segment)
        }
    }
}
