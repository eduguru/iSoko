//
//  EventScheduleCell.swift
//  
//
//  Created by Edwin Weru on 03/08/2026.
//

import UIKit
import Kingfisher

public final class EventScheduleCell: UITableViewCell {

    // MARK: - Views
    private let bannerImageView = UIImageView()
    private let containerView = UIView()

    private let monthLabel = UILabel()
    private let startDayLabel = UILabel()
    private let toLabel = UILabel()
    private let endDayLabel = UILabel()
    private let dateStack = UIStackView()

    private let titleLabel = UILabel()

    private let locationIconContainer = UIView()
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()

    private let timeIconContainer = UIView()
    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()

    private let locationRow = UIStackView()
    private let timeRow = UIStackView()

    private let descriptionLabel = UILabel()
    private let dividerView = UIView()
    private let detailsButton = InlineActionButton()

    private let rightStack = UIStackView()
    private let rootStack = UIStackView()
    private let mainStack = UIStackView()

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.preferredMaxLayoutWidth = rightStack.bounds.width
    }

    // MARK: - Reuse
    // 👇 Reset ALL stateful properties so nothing carries over on segment switch
    public override func prepareForReuse() {
        super.prepareForReuse()

        bannerImageView.image = nil
        bannerImageView.isHidden = false   // 👈 critical — reset before configure sets it

        descriptionLabel.attributedText = nil
        descriptionLabel.text = nil

        titleLabel.text = nil
        locationLabel.text = nil
        timeLabel.text = nil
        monthLabel.text = nil
        startDayLabel.text = nil
        endDayLabel.text = nil
        toLabel.text = nil

        detailsButton.isHidden = false
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        // MARK: Banner Image
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.layer.cornerRadius = 16

        NSLayoutConstraint.activate([
            bannerImageView.heightAnchor.constraint(equalToConstant: 180)
        ])

        // MARK: Date Labels
        monthLabel.font = .preferredFont(forTextStyle: .caption1)
        monthLabel.textAlignment = .center

        startDayLabel.font = .systemFont(ofSize: 28, weight: .bold)
        startDayLabel.textAlignment = .center

        toLabel.font = .preferredFont(forTextStyle: .caption2)
        toLabel.textAlignment = .center

        endDayLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        endDayLabel.textAlignment = .center

        dateStack.axis = .vertical
        dateStack.alignment = .center
        dateStack.spacing = 4
        dateStack.addArrangedSubview(monthLabel)
        dateStack.addArrangedSubview(startDayLabel)
        dateStack.addArrangedSubview(toLabel)
        dateStack.addArrangedSubview(endDayLabel)

        NSLayoutConstraint.activate([
            dateStack.widthAnchor.constraint(equalToConstant: 56)
        ])

        // MARK: Title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0

        // MARK: Icons
        configureIconContainer(locationIconContainer, imageView: locationImageView)
        configureIconContainer(timeIconContainer, imageView: timeImageView)

        // MARK: Labels
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        locationLabel.numberOfLines = 2

        timeLabel.font = .preferredFont(forTextStyle: .subheadline)

        descriptionLabel.font = .preferredFont(forTextStyle: .footnote)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.lineBreakMode = .byTruncatingTail

        // MARK: Location Row
        locationRow.axis = .horizontal
        locationRow.alignment = .top
        locationRow.spacing = 10
        locationRow.addArrangedSubview(locationIconContainer)
        locationRow.addArrangedSubview(locationLabel)

        // MARK: Time Row
        timeRow.axis = .horizontal
        timeRow.alignment = .center
        timeRow.spacing = 10
        timeRow.addArrangedSubview(timeIconContainer)
        timeRow.addArrangedSubview(timeLabel)

        // MARK: Divider
        dividerView.backgroundColor = .systemGray5
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])

        // MARK: Right Stack
        rightStack.axis = .vertical
        rightStack.spacing = 12
        rightStack.addArrangedSubview(titleLabel)
        rightStack.addArrangedSubview(locationRow)
        rightStack.addArrangedSubview(timeRow)
        rightStack.addArrangedSubview(descriptionLabel)
        rightStack.addArrangedSubview(dividerView)
        rightStack.addArrangedSubview(detailsButton)
        rightStack.setContentHuggingPriority(.required, for: .vertical)
        rightStack.setContentCompressionResistancePriority(.required, for: .vertical)

        // MARK: Root Stack
        rootStack.axis = .horizontal
        rootStack.alignment = .top
        rootStack.spacing = 20
        rootStack.addArrangedSubview(dateStack)
        rootStack.addArrangedSubview(rightStack)

        // MARK: Main Stack
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.addArrangedSubview(bannerImageView)
        mainStack.addArrangedSubview(rootStack)

        containerView.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func configureIconContainer(_ container: UIView, imageView: UIImageView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 28),
            container.heightAnchor.constraint(equalToConstant: 28),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        container.layer.cornerRadius = 14
    }

    // MARK: - Configure

    public func configure(with config: EventScheduleCellConfig) {

        // MARK: Banner
        // 👇 Always explicitly set both image and hidden state
        if let url = config.bannerImageURL {
            bannerImageView.isHidden = false
            bannerImageView.kf.setImage(with: url)
        } else {
            bannerImageView.isHidden = true
            bannerImageView.image = nil
        }

        // MARK: Date
        monthLabel.text = config.month.uppercased()
        startDayLabel.text = config.startDay
        endDayLabel.text = config.endDay
        toLabel.text = "to"

        // MARK: Content
        titleLabel.text = config.title
        locationLabel.text = config.location
        timeLabel.text = config.time

        // 👇 Set preferredMaxLayoutWidth before attributed string so height resolves correctly on first pass
        descriptionLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32 - 32 - 56 - 20
        descriptionLabel.attributedText = config.description.htmlToAttributedString(
            font: .preferredFont(forTextStyle: .footnote),
            textColor: config.descriptionColor
        )
        descriptionLabel.invalidateIntrinsicContentSize()

        // MARK: Colors
        monthLabel.textColor = config.monthColor
        startDayLabel.textColor = config.dayColor
        endDayLabel.textColor = config.dayColor
        toLabel.textColor = config.separatorColor
        titleLabel.textColor = config.titleColor
        locationLabel.textColor = config.bodyColor
        timeLabel.textColor = config.bodyColor
        descriptionLabel.textColor = config.descriptionColor

        // MARK: Icons
        locationImageView.image = config.locationIcon?.withRenderingMode(.alwaysTemplate)
        timeImageView.image = config.timeIcon?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = config.iconTintColor
        timeImageView.tintColor = config.iconTintColor
        locationIconContainer.backgroundColor = config.iconBackgroundColor
        timeIconContainer.backgroundColor = config.iconBackgroundColor

        // MARK: Action
        if let action = config.detailsAction {
            detailsButton.configure(with: action)
            detailsButton.isHidden = false
        } else {
            detailsButton.isHidden = true
        }

        // MARK: Card
        containerView.backgroundColor = config.cardBackgroundColor
        containerView.layer.cornerRadius = config.cardCornerRadius
        containerView.layer.borderWidth = config.cardBorderWidth
        containerView.layer.borderColor = config.cardBorderColor.cgColor
    }
}
