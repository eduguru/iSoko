//
//  TermsConditionsViewModel.swift
//
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class TermsConditionsViewModel: FormViewModel {
    
    // MARK: - Internal state
    private var state: State
    private let directusService = DirectusTokenService()
    
    // MARK: - Initialization
    override init() {
        state = State()
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Refresh
    override func refresh() {
        fetchData()
    }
    
    // MARK: - Fetch Data
    override func fetchData() {
        showLoader()
        defer { hideLoader() }
        
        Task {
            do {
                try await directusService.login(
                    email: AppStorage.email,
                    password: AppStorage.password
                )
                
                let items = try await directusService.fetchTermsAndConditions()
                state.items = items
                print("✅ Directus flow successful. Items:", items)
                
                // Update the body section dynamically
                updateBodySection()
                
            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeBodySection()
        ]
    }
    
    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            title: "Terms and Conditions",
            cells: [] // Start empty, populate after fetch
        )
    }
    
    // MARK: - Update Section
    private func updateBodySection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.body.rawValue }) else { return }
        
        var cells: [FormRow] = []
        
        for (index, item) in state.items.enumerated() {
            // Term content row
            let row = RichDescriptionFormRow(
                tag: 1000 + index,
                model: RichDescriptionModel(
                    title: "",
                    htmlDescription: item.content ?? "No content available",
                    textAlignment: .left
                )
            )
            cells.append(row)
            
            // Add a small spacer after each term
            let spacer = SpacerFormRow(tag: 2000 + index, height: 20)
            cells.append(spacer)
        }
        
        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }
    
    // MARK: - State
    private struct State {
        var items: [TermsAndConditionsItem] = []
        
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }
    
    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
        
        enum Cells: Int {
            case body = 0
        }
    }
}
