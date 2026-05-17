//
//  PromoCodeFormCell.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

import UIKit

public final class PromoCodeFormCell: UITableViewCell {

    // MARK: - Views

    private let cardView = UIView()

    private let contentViewContainer = UIView()

    private let stackView = UIStackView()

    private let titleLabel = UILabel()

    private let subtitleLabel = UILabel()

    private let codeContainer = UIView()

    private let codeLabel = UILabel()

    private let copyButton = UIButton(type: .system)

    // MARK: - Actions

    private var copyAction: (() -> Void)?

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {

        selectionStyle = .none

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // MARK: Card View

        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([

            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            cardView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            )
        ])

        // MARK: Content Container (IMPORTANT FIX)

        contentViewContainer.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentViewContainer)

        NSLayoutConstraint.activate([

            contentViewContainer.topAnchor.constraint(equalTo: cardView.topAnchor),
            contentViewContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            contentViewContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            contentViewContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        contentViewContainer.clipsToBounds = true

        // MARK: Stack View

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentViewContainer.addSubview(stackView)

        // MARK: Title

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 24)

        // MARK: Subtitle

        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .secondaryLabel

        // MARK: Code Container

        codeContainer.translatesAutoresizingMaskIntoConstraints = false

        codeContainer.backgroundColor =
            UIColor.secondarySystemBackground

        codeContainer.layer.cornerRadius = 14

        codeContainer.layer.borderWidth = 1

        codeContainer.layer.borderColor =
            UIColor.systemGray4.cgColor

        // MARK: Code Label

        codeLabel.translatesAutoresizingMaskIntoConstraints = false

        codeLabel.font =
            .monospacedSystemFont(
                ofSize: 32,
                weight: .bold
            )

        codeLabel.textAlignment = .center
        codeLabel.textColor = .label

        codeContainer.addSubview(codeLabel)

        NSLayoutConstraint.activate([

            codeLabel.topAnchor.constraint(
                equalTo: codeContainer.topAnchor,
                constant: 16
            ),

            codeLabel.bottomAnchor.constraint(
                equalTo: codeContainer.bottomAnchor,
                constant: -16
            ),

            codeLabel.leadingAnchor.constraint(
                equalTo: codeContainer.leadingAnchor,
                constant: 20
            ),

            codeLabel.trailingAnchor.constraint(
                equalTo: codeContainer.trailingAnchor,
                constant: -20
            )
        ])

        // MARK: Copy Button

        copyButton.titleLabel?.font =
            .boldSystemFont(ofSize: 18)

        copyButton.setTitleColor(
            .white,
            for: .normal
        )

        copyButton.backgroundColor = .app(.primary)

        copyButton.layer.cornerRadius = 14

        copyButton.contentEdgeInsets =
            UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )

        copyButton.addTarget(
            self,
            action: #selector(copyTapped),
            for: .touchUpInside
        )

        // MARK: Add Views

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(codeContainer)
        stackView.addArrangedSubview(copyButton)

        // MARK: Stack Constraints (WITH SAFE INSETS)

        NSLayoutConstraint.activate([

            stackView.topAnchor.constraint(
                equalTo: contentViewContainer.topAnchor,
                constant: 16
            ),

            stackView.leadingAnchor.constraint(
                equalTo: contentViewContainer.leadingAnchor,
                constant: 16
            ),

            stackView.trailingAnchor.constraint(
                equalTo: contentViewContainer.trailingAnchor,
                constant: -16
            ),

            stackView.bottomAnchor.constraint(
                equalTo: contentViewContainer.bottomAnchor,
                constant: -16
            )
        ])

        // MARK: Full width elements

        codeContainer.widthAnchor.constraint(
            equalTo: stackView.widthAnchor
        ).isActive = true

        copyButton.widthAnchor.constraint(
            equalTo: stackView.widthAnchor
        ).isActive = true
    }

    // MARK: - Configure

    public func configure(
        with model: PromoCodeModel
    ) {

        copyAction = model.onCopyTapped

        // MARK: Card Style

        cardView.backgroundColor =
            model.cardSettings.backgroundColor

        cardView.layer.cornerRadius =
            model.cardSettings.cornerRadius

        // MARK: Dashed Border

        cardView.layer.sublayers?
            .removeAll(where: {
                $0.name == "DashedBorder"
            })

        let dashedBorder = CAShapeLayer()

        dashedBorder.name = "DashedBorder"

        dashedBorder.strokeColor =
            UIColor.systemGray3.cgColor

        dashedBorder.lineWidth = 1.5

        dashedBorder.lineDashPattern = [6, 4]

        dashedBorder.fillColor = nil

        dashedBorder.path = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: model.cardSettings.cornerRadius
        ).cgPath

        dashedBorder.frame = cardView.bounds

        cardView.layer.addSublayer(dashedBorder)

        // MARK: Text

        titleLabel.text = model.title

        subtitleLabel.text = model.subtitle

        subtitleLabel.isHidden =
            model.subtitle?.isEmpty ?? true

        codeLabel.text =
            model.code.uppercased()

        copyButton.setTitle(
            model.buttonTitle,
            for: .normal
        )
    }

    // MARK: - Layout

    public override func layoutSubviews() {

        super.layoutSubviews()

        cardView.layer.sublayers?
            .compactMap { $0 as? CAShapeLayer }
            .first(where: {
                $0.name == "DashedBorder"
            })?
            .path = UIBezierPath(
                roundedRect: cardView.bounds,
                cornerRadius: cardView.layer.cornerRadius
            ).cgPath
    }

    // MARK: - Actions

    @objc
    private func copyTapped() {

        UIPasteboard.general.string =
            codeLabel.text

        copyAction?()
    }
}
