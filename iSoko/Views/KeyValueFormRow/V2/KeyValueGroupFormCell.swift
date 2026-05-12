//
//  KeyValueGroupFormCell.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import UIKit

public final class KeyValueGroupFormCell: UITableViewCell {

    // MARK: - Container (same role as ProfileInfoCell)
    private let containerView = UIView()

    // MARK: - Stack (single layout engine)
    private let contentStack = UIStackView()

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

        // Container = spacing authority (LIKE YOUR WORKING CELL)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Stack = ONLY layout engine
        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(contentStack)

        NSLayoutConstraint.activate([

            // OUTER padding (THIS is what you were missing conceptually)
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // INNER padding (same pattern as ProfileInfoCell)
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }

    // MARK: - Configure
    public func configure(with model: KeyValueGroupModel) {

        // Clear reuse safely
        contentStack.arrangedSubviews.forEach {
            contentStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Card is NOT a layout layer anymore — it's styling only
        applyCard(model.card)

        // Title (optional)
        if let title = model.sectionTitle, !title.isEmpty {
            contentStack.addArrangedSubview(makeTitleView(title))
        }

        // Rows
        for row in model.rows {
            contentStack.addArrangedSubview(makeRowView(from: row))
        }
    }

    // MARK: - Title
    private func makeTitleView(_ title: String) -> UIView {

        let label = UILabel()
        label.text = title.uppercased()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label

        let container = UIView()
        container.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        return container
    }

    // MARK: - Row (same logic as before, but stable)
    private func makeRowView(from model: KeyValueRowModel) -> UIView {

        let left = UILabel()
        let right = UILabel()

        left.text = model.leftText
        right.text = model.rightText

        left.numberOfLines = model.maxLeftLines == 0 ? 0 : model.maxLeftLines
        right.numberOfLines = model.maxRightLines == 0 ? 0 : model.maxRightLines

        left.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        right.setContentHuggingPriority(.required, for: .horizontal)
        right.textAlignment = .right

        let spacer = UIView()

        let stack = UIStackView(arrangedSubviews: [left, spacer, right])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8

        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        return stack
    }

    // MARK: - Card (NOW only styling, not layout authority)
    private func applyCard(_ card: CardSettings?) {

        guard let card else {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = 0
            containerView.layer.borderWidth = 0
            return
        }

        containerView.backgroundColor = card.backgroundColor
        containerView.layer.cornerRadius = card.cornerRadius
        containerView.layer.borderWidth = card.borderWidth
        containerView.layer.borderColor = card.borderColor?.cgColor
    }
}
