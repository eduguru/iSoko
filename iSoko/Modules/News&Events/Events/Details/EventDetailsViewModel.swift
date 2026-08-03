//
//  EventDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 03/08/2026.
//

import DesignSystemKit
import Foundation
import UIKit

final class EventDetailViewModel: FormViewModel {

    var onRegisterTapped: ((URL) -> Void)?

    private var state: State

    init(_ event: UnifiedEventItem) {
        self.state = State(event: event)
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection(),
            makeInfoSection(),
            makeContactSection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [headerImage, headerTitle, headerMeta]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: [bodyText]
        )
    }

    private func makeInfoSection() -> FormSection {
        FormSection(
            id: Tags.Section.info.rawValue,
            cells: makeInfoCells()
        )
    }

    private func makeContactSection() -> FormSection {
        FormSection(
            id: Tags.Section.contact.rawValue,
            cells: makeContactCells()
        )
    }

    // MARK: - Lazy Rows

    private lazy var headerImage: FormRow = makeHeaderImageRow()
    private lazy var headerTitle: FormRow = makeHeaderTitleRow()
    private lazy var headerMeta: FormRow = makeHeaderMetaRow()
    private lazy var bodyText: FormRow = makeBodyTextRow()

    // MARK: - Header Image

    private func makeHeaderImageRow() -> FormRow {
        ImageFormRow(
            tag: Tags.Cells.image.rawValue,
            config: .init(
                image: .blankRectangle,
                imageURL: state.event.bannerImageURL,
                height: 200,
                fillWidth: true,
                aspectRatio: 16 / 9
            )
        )
    }

    // MARK: - Title

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.title.rawValue,
            model: TitleDescriptionModel(
                title: state.event.eventTitle ?? "",
                description: state.event.eventType ?? "",
                maxTitleLines: 2,
                maxDescriptionLines: 1,
                titleEllipsis: .tail,
                descriptionEllipsis: .tail,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }

    // MARK: - Meta

    private func makeHeaderMetaRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.meta.rawValue,
            model: TitleDescriptionModel(
                title: state.event.organizingInstitution ?? "",
                description: state.event.status ?? "",
                maxTitleLines: 1,
                maxDescriptionLines: 1,
                titleEllipsis: .tail,
                descriptionEllipsis: .tail,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }

    // MARK: - Body

    private func makeBodyTextRow() -> FormRow {
        RichDescriptionFormRow(
            tag: Tags.Cells.body.rawValue,
            model: RichDescriptionModel(
                title: "",
                htmlDescription: state.event.description ?? "",
                textAlignment: .left
            )
        )
    }

    // MARK: - Info (date, time, venue)

    private func makeInfoCells() -> [FormRow] {
        var cells: [FormRow] = []

        let dateText = formatDateRange()
        if !dateText.isEmpty {
            cells.append(
                makeInfoRow(
                    tag: Tags.Cells.date.rawValue,
                    icon: UIImage(systemName: "calendar"),
                    title: dateText,
                    subtitle: formatTimeRange()
                )
            )
        }

        if let venue = state.event.venue ?? state.event.location, !venue.isEmpty {
            cells.append(
                makeInfoRow(
                    tag: Tags.Cells.venue.rawValue,
                    icon: UIImage(systemName: "mappin.and.ellipse"),
                    title: venue,
                    subtitle: nil
                )
            )
        }

        if let link = state.event.registrationLink, let url = URL(string: link) {
            cells.append(
                ButtonFormRow(
                    tag: Tags.Cells.register.rawValue,
                    model: ButtonFormModel(
                        title: "Register",
                        style: .primary,
                        size: .medium,
                        fontStyle: .headline,
                        hapticsEnabled: true
                    ) { [weak self] in
                        self?.onRegisterTapped?(url)
                    }
                )
            )
        }

        return cells
    }

    // MARK: - Contact

    private func makeContactCells() -> [FormRow] {
        var cells: [FormRow] = []

        if let email = state.event.contactEmail, !email.isEmpty {
            cells.append(
                makeInfoRow(
                    tag: Tags.Cells.email.rawValue,
                    icon: UIImage(systemName: "envelope"),
                    title: email,
                    subtitle: nil
                )
            )
        }

        if let phone = state.event.contactNumber, !phone.isEmpty {
            cells.append(
                makeInfoRow(
                    tag: Tags.Cells.phone.rawValue,
                    icon: UIImage(systemName: "phone"),
                    title: phone,
                    subtitle: nil
                )
            )
        }

        if !cells.isEmpty {
            cells.append(SpacerFormRow(tag: Tags.Cells.spacer.rawValue, height: 40))
        }

        return cells
    }

    // MARK: - Shared Row Builder

    private func makeInfoRow(tag: Int, icon: UIImage?, title: String, subtitle: String?) -> FormRow {
        ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: icon,
                imageStyle: .rounded,
                title: title,
                description: subtitle ?? "",
                accessoryType: .none,
                onTap: nil,
                isCardStyleEnabled: true
            )
        )
    }

    // MARK: - Date Helpers

    private func formatDateRange() -> String {
        [state.event.startDate, state.event.endDate]
            .compactMap { $0 }
            .joined(separator: " – ")
    }

    private func formatTimeRange() -> String {
        [state.event.startTime, state.event.endTime]
            .compactMap { $0 }
            .joined(separator: " – ")
    }

    // MARK: - State

    private struct State {
        let event: UnifiedEventItem
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
            case info = 2
            case contact = 3
        }
        enum Cells: Int {
            case image = 1
            case title = 101
            case meta = 102
            case body = 3001
            case date = 201
            case venue = 202
            case register = 203
            case email = 301
            case phone = 302
            case spacer = 999
        }
    }
}
