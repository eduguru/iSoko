//
//  EventsListingViewModel.swift
//  
//
//  Created by Edwin Weru on 24/05/2026.
//

import DesignSystemKit
import UIKit
import StorageKit

final class EventsListingViewModel: FormViewModel {
    
    // MARK: - Navigation
//    var goToEventDetails: ((EventItem) -> Void)? = { _ in }
//    var goToAssociationEventDetails: ((AssociationEventItem) -> Void)? = { _ in }
    
    var goToEventDetails: ((UnifiedEventItem) -> Void)?
    
    // MARK: - Service
    private let directusService = DirectusTokenService()
    
    // MARK: - State
    private var state = State()
    
    // MARK: - Init
    override init() {
        super.init()
        sections = makeSections()
        reloadBodySection(animated: false)
    }
    
    // MARK: - Lifecycle
    
    override func refresh() {
        fetchData()
    }
    
    override func fetchData() {
        showLoader()

        Task {
            do {
                try await directusService.login(
                    email: AppStorage.email,
                    password: AppStorage.password
                )

                async let publicEventsTask = directusService.fetchEvents()
                async let associationEventsTask = directusService.fetchAssociationEvents()

                let publicEvents = try await publicEventsTask
                let associationEvents = try await associationEventsTask

                state.events = publicEvents
                state.associationEvents = associationEvents

                await MainActor.run { [weak self] in
                    self?.hideLoader()
                    self?.reloadBodySection(animated: true)
                }

            } catch {
                await MainActor.run { [weak self] in
                    self?.hideLoader()
                }
                print("❌ Events flow failed:", error)
            }
        }
    }
    
    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            FormSection(id: SectionTag.publicEvents.rawValue, cells: []),
            FormSection(id: SectionTag.associationEvents.rawValue, cells: [])
        ]
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: SectionTag.header.rawValue,
            title: "Events",
            cells: [segmentedOptions]
        )
    }
    
    // MARK: - Reload

    private func reloadBodySection(animated: Bool = true) {
        guard
            let publicIndex = sections.firstIndex(where: { $0.id == SectionTag.publicEvents.rawValue }),
            let associationIndex = sections.firstIndex(where: { $0.id == SectionTag.associationEvents.rawValue })
        else { return }

        switch state.selectedSegmentIndex {
        case 0:
            sections[publicIndex].cells = makePublicEventsCells()
            sections[publicIndex].cells.append(SpacerFormRow(tag: 999998, height: 40))
            sections[associationIndex].cells = []

        case 1:
            sections[publicIndex].cells = []
            sections[associationIndex].cells = makeAssociationEventsCells()
            sections[associationIndex].cells.append(SpacerFormRow(tag: 999999, height: 40))

        default:
            sections[publicIndex].cells = []
            sections[associationIndex].cells = []
        }

        reloadSection(publicIndex)
        reloadSection(associationIndex)
    }
    
    // MARK: - Segmented Control

    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: [
                    "Public Events",
                    "Association Events"
                ],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }
                    self.state.selectedSegmentIndex = index
                    self.reloadBodySection(animated: true)
                }
            )
        )
    }

    // MARK: - Row Builders
    
    private func makePublicEventsCells() -> [FormRow] {
        state.events.enumerated().map { index, item in

            let startDate = item.startDate.flatMap { formatEventDateParts($0) }

            let location = [item.venue, item.location]
                .compactMap { $0 }
                .joined(separator: ", ")

            let time = [item.startTime, item.endTime]
                .compactMap { $0 }
                .joined(separator: " - ")

            let config = EventScheduleCellConfig(
                month: startDate?.month ?? "N/A",
                startDay: startDate?.day ?? "--",
                endDay: startDate?.day ?? "--",
                title: item.eventTitle ?? "No Title",
                location: location.isEmpty ? "No Location" : location,
                time: time.isEmpty ? "No Time" : time,
                description: item.description ?? "",
                locationIcon: UIImage(systemName: "mappin.and.ellipse"),
                timeIcon: UIImage(systemName: "clock"),
                bannerImageURL: nil,
                detailsAction: InlineActionConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "arrow.right"),
                    onTap: { [weak self] in
                        self?.handleEventTap(index: index)
                    }
                ),
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray5,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )

            return EventScheduleRow(tag: 9000 + index, config: config)
        }
    }

    private func makeAssociationEventsCells() -> [FormRow] {
        state.associationEvents.enumerated().map { index, item in

            let startDate = item.startDate.flatMap { formatEventDateParts($0) }

            let location = [item.venue, item.physicalAddress]
                .compactMap { $0 }
                .joined(separator: ", ")

            let time = [item.startTime, item.endTime]
                .compactMap { $0 }
                .joined(separator: " - ")

            let config = EventScheduleCellConfig(
                month: startDate?.month ?? "N/A",
                startDay: startDate?.day ?? "--",
                endDay: startDate?.day ?? "--",
                title: item.eventTitle ?? "No Title",
                location: location.isEmpty ? "No Location" : location,
                time: time.isEmpty ? "No Time" : time,
                description: item.description ?? "",
                locationIcon: UIImage(systemName: "mappin.and.ellipse"),
                timeIcon: UIImage(systemName: "clock"),
                bannerImageURL: item.bannerImage?.url,
                detailsAction: InlineActionConfig(
                    title: "View Details",
                    icon: UIImage(systemName: "arrow.right"),
                    onTap: { [weak self] in
                        self?.handleAssociationEventTap(index: index)
                    }
                ),
                cardBackgroundColor: .white,
                cardBorderColor: .systemGray5,
                cardBorderWidth: 1,
                cardCornerRadius: 12
            )

            return EventScheduleRow(tag: 10000 + index, config: config)
        }
    }

    // MARK: - Tap Handlers

//    private func handleEventTap(index: Int) {
//        guard state.events.indices.contains(index) else { return }
//        goToEventDetails?(state.events[index])
//    }
//    
//    private func handleAssociationEventTap(index: Int) {
//        guard state.associationEvents.indices.contains(index) else { return }
//        goToAssociationEventDetails?(state.associationEvents[index])
//    }
    
    private func handleEventTap(index: Int) {
        guard state.events.indices.contains(index) else { return }
        goToEventDetails?(state.events[index].toUnified())
    }

    private func handleAssociationEventTap(index: Int) {
        guard state.associationEvents.indices.contains(index) else { return }
        goToEventDetails?(state.associationEvents[index].toUnified())
    }

    // MARK: - Date Helpers

    private func formatEventDateParts(_ dateString: String) -> (month: String, day: String)? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return nil }

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"

        return (monthFormatter.string(from: date), dayFormatter.string(from: date))
    }

    private func formatEventDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: isoString) else { return "No Date" }

        let display = DateFormatter()
        display.dateFormat = "dd MMM yyyy"
        display.locale = .current
        display.timeZone = .current
        return display.string(from: date)
    }
    
    // MARK: - State

    private struct State {
        var selectedSegmentIndex: Int = 0
        var events: [EventItem] = []
        var associationEvents: [AssociationEventItem] = []
    }
    
    // MARK: - Tags

    private enum SectionTag: Int {
        case header = 0
        case publicEvents = 1
        case associationEvents = 2
    }
}
