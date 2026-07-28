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
    var goToEventDetails: ((EventItem) -> Void)? = { _ in }
    var goToAssociationEventDetails: ((AssociationEventItem) -> Void)? = { _ in }
    
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
    
    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
    }
    
    private func makeHeaderSection() -> FormSection {

        FormSection(
            id: SectionTag.header.rawValue,
            title: "Events",
            cells: [
                segmentedOptions
            ]
        )
    }

    
    private func makeBodySection() -> FormSection {
        FormSection(
            id: SectionTag.body.rawValue,
            cells: []
        )
    }
    
    private func reloadBodySection(animated: Bool = true) {

        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.body.rawValue
        }) else { return }

        switch state.selectedSegmentIndex {

        case 0:
            sections[index].cells = makePublicEventsCells()

        case 1:
            sections[index].cells = makeAssociationEventsCells()

        default:
            sections[index].cells = []
        }

        sections[index].cells.append(
            SpacerFormRow(tag: 999999, height: 40)
        )

        reloadSection(index)
    }
    
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

    
    private func makePublicEventsCells() -> [FormRow] {
        
        state.events.enumerated().map { index, item in
            
            let startDateText: String = {
                guard let dateString = item.startDate else { return "No Date" }
                return formatEventDate(dateString)
            }()
            
            return InfoListingFormRow(
                tag: 9000 + index,
                model: InfoListingModel(
                    title: item.eventTitle ?? "No Title",
                    subtitle: item.eventType ?? "",
                    desc: startDateText,
                    icon: .blankRectangle,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleEventTap(index: index)
                    }
                )
            )
        }
    }
    
    private func makeAssociationEventsCells() -> [FormRow] {

        state.associationEvents.enumerated().map { index, item in

            let startDateText: String = {
                guard let dateString = item.startDate else {
                    return "No Date"
                }
                return formatEventDate(dateString)
            }()

            return InfoListingFormRow(
                tag: 10000 + index,
                model: InfoListingModel(
                    title: item.eventTitle ?? "No Title",
                    subtitle: item.eventType ?? "",
                    desc: startDateText,
                    icon: .blankRectangle,
                    cardBackgroundColor: .white,
                    cardRadius: 0,
                    onTap: { [weak self] in
                        self?.handleAssociationEventTap(index: index)
                    }
                )
            )
        }
    }

    
    private func handleEventTap(index: Int) {
        
        guard state.events.indices.contains(index) else { return }
        
        let item = state.events[index]
        goToEventDetails?(item)
    }
    
    private func handleAssociationEventTap(index: Int) {

        guard state.associationEvents.indices.contains(index) else {
            return
        }

        let item = state.associationEvents[index]
        goToAssociationEventDetails?(item)
    }

    
    private func formatEventDate(_ isoString: String) -> String {
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        let date = formatter.date(from: isoString)
        
        guard let date else { return "No Date" }
        
        let display = DateFormatter()
        display.dateFormat = "dd MMM yyyy"
        display.locale = .current
        display.timeZone = .current
        
        return display.string(from: date)
    }
    
    private struct State {
        var selectedSegmentIndex: Int = 0

        var events: [EventItem] = []
        var associationEvents: [AssociationEventItem] = []
    }
    
    private enum SectionTag: Int {
        case header = 0
        case body = 1
    }
    
}
