//
//  EventScheduleCellConfig.swift
//  
//
//  Created by Edwin Weru on 03/08/2026.
//

import UIKit

public struct EventScheduleCellConfig {

    // MARK: - Date
    public let month: String
    public let startDay: String
    public let endDay: String

    // MARK: - Content
    public let title: String
    public let location: String
    public let time: String
    public let description: String

    // MARK: - Icons
    public let locationIcon: UIImage?
    public let timeIcon: UIImage?

    // MARK: - Action
    public let detailsAction: InlineActionConfig?

    // MARK: - Card Styling
    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
    public let cardCornerRadius: CGFloat

    // MARK: - Date Styling
    public let monthColor: UIColor
    public let dayColor: UIColor
    public let separatorColor: UIColor

    // MARK: - Text Styling
    public let titleColor: UIColor
    public let bodyColor: UIColor
    public let descriptionColor: UIColor

    // MARK: - Icon Styling
    public let iconTintColor: UIColor
    public let iconBackgroundColor: UIColor
    
    public let bannerImageURL: URL?

    public init(
        month: String,
        startDay: String,
        endDay: String,
        title: String,
        location: String,
        time: String,
        description: String,
        locationIcon: UIImage?,
        timeIcon: UIImage?,
        bannerImageURL: URL? = nil,
        detailsAction: InlineActionConfig? = nil,
        cardBackgroundColor: UIColor = .systemBackground,
        cardBorderColor: UIColor = .systemGray5,
        cardBorderWidth: CGFloat = 1,
        cardCornerRadius: CGFloat = 12,
        monthColor: UIColor = .systemOrange,
        dayColor: UIColor = .label,
        separatorColor: UIColor = .secondaryLabel,
        titleColor: UIColor = .label,
        bodyColor: UIColor = .label,
        descriptionColor: UIColor = .secondaryLabel,
        iconTintColor: UIColor = .systemGreen,
        iconBackgroundColor: UIColor = UIColor.systemGreen.withAlphaComponent(0.12)
    ) {

        self.bannerImageURL = bannerImageURL

        self.month = month
        self.startDay = startDay
        self.endDay = endDay

        self.title = title
        self.location = location
        self.time = time
        self.description = description

        self.locationIcon = locationIcon
        self.timeIcon = timeIcon

        self.detailsAction = detailsAction

        self.cardBackgroundColor = cardBackgroundColor
        self.cardBorderColor = cardBorderColor
        self.cardBorderWidth = cardBorderWidth
        self.cardCornerRadius = cardCornerRadius

        self.monthColor = monthColor
        self.dayColor = dayColor
        self.separatorColor = separatorColor

        self.titleColor = titleColor
        self.bodyColor = bodyColor
        self.descriptionColor = descriptionColor

        self.iconTintColor = iconTintColor
        self.iconBackgroundColor = iconBackgroundColor
    }
}
