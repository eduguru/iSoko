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
                
                // ensure auth (same pattern as InsightsViewModel)
                try await directusService.login(
                    email: AppStorage.email,
                    password: AppStorage.password
                )
                
                let events = try await directusService.fetchEvents()
                
                state.events = events
                
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
            cells: []
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
        
        sections[index].cells = makeEventsCells()
        sections[index].cells.append(
            SpacerFormRow(tag: 999999, height: 40)
        )
        
        reloadSection(index)
    }
    
    private func makeEventsCells() -> [FormRow] {
        
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
    
    private func handleEventTap(index: Int) {
        
        guard state.events.indices.contains(index) else { return }
        
        let item = state.events[index]
        goToEventDetails?(item)
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
        var events: [EventItem] = []
    }
    
    private enum SectionTag: Int {
        case header = 0
        case body = 1
    }
    
}
