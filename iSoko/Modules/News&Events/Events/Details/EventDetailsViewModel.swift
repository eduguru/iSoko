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
            makeLocationSection(),
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
            cells: makeDateCells()
        )
    }

    private func makeLocationSection() -> FormSection {
        FormSection(
            id: Tags.Section.location.rawValue,
            cells: makeLocationCells()
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

    // MARK: - Date & Time

    private func makeDateCells() -> [FormRow] {
        var items: [InfoPairItem] = []

        if let start = state.event.startDate {
            items.append(InfoPairItem(
                icon: UIImage(systemName: "calendar"),
                label: "Start Date",
                value: formatDate(start, time: state.event.startTime)
            ))
        }

        if let end = state.event.endDate {
            items.append(InfoPairItem(
                icon: UIImage(systemName: "calendar.badge.checkmark"),
                label: "End Date",
                value: formatDate(end, time: state.event.endTime)
            ))
        }

        guard !items.isEmpty else { return [] }

        return [
            InfoPairFormRow(
                tag: Tags.Cells.date.rawValue,
                config: InfoPairConfig(
                    title: "Date and Time",
                    items: items
                )
            )
        ]
    }

    // MARK: - Location

    private func makeLocationCells() -> [FormRow] {
        guard let venue = state.event.venue ?? state.event.location,
              !venue.isEmpty else { return [] }

        return [
            InfoPairFormRow(
                tag: Tags.Cells.venue.rawValue,
                config: InfoPairConfig(
                    title: "Location Information",
                    items: [
                        InfoPairItem(
                            icon: UIImage(systemName: "mappin.and.ellipse"),
                            label: venue
                        )
                    ]
                )
            )
        ]
    }

    // MARK: - Contact

    private func makeContactCells() -> [FormRow] {
        var items: [InfoPairItem] = []

        if let org = state.event.organizingInstitution, !org.isEmpty {
            items.append(InfoPairItem(
                icon: UIImage(systemName: "building.2"),
                label: org,
                value: "Organizer"
            ))
        }

        if let email = state.event.contactEmail, !email.isEmpty {
            items.append(InfoPairItem(
                icon: UIImage(systemName: "envelope"),
                label: "Email",
                value: email,
                valueColor: .systemBlue,
                isLink: true,
                onTap: {
                    guard let url = URL(string: "mailto:\(email)") else { return }
                    UIApplication.shared.open(url)
                }
            ))
        }

        if let phone = state.event.contactNumber, !phone.isEmpty {
            items.append(InfoPairItem(
                icon: UIImage(systemName: "phone"),
                label: "Phone Number",
                value: phone,
                onTap: {
                    guard let url = URL(string: "tel:\(phone)") else { return }
                    UIApplication.shared.open(url)
                }
            ))
        }

        var cells: [FormRow] = []

        if !items.isEmpty {
            cells.append(
                InfoPairFormRow(
                    tag: Tags.Cells.contact.rawValue,
                    config: InfoPairConfig(
                        title: "Contact Information",
                        items: items
                    )
                )
            )
        }

        // Register button
        if let link = state.event.registrationLink,
           let url = URL(string: link) {
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

        if !cells.isEmpty {
            cells.append(SpacerFormRow(tag: Tags.Cells.spacer.rawValue, height: 40))
        }

        return cells
    }

    // MARK: - Date Helpers

    private func formatDate(_ date: String, time: String?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let d = formatter.date(from: date) else { return date }

        let display = DateFormatter()
        display.dateFormat = "MMM dd, yyyy"
        var result = display.string(from: d)

        if let time, !time.isEmpty {
            result += ", \(time)"
        }
        return result
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
            case location = 3
            case contact = 4
        }
        enum Cells: Int {
            case image = 1
            case title = 101
            case meta = 102
            case body = 3001
            case date = 201
            case venue = 202
            case register = 203
            case contact = 301
            case spacer = 999
        }
    }
}
