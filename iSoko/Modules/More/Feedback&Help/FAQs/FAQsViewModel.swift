//
//  FAQsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class FAQsViewModel: FormViewModel {
    
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
                
                let items = try await directusService.fetchFAQs()
                state.items = items
                print("✅ Directus flow successful. Items:", items)
                
                // Update the FAQ section dynamically
                updateFAQSection()
                
            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeFAQSection()
        ]
    }
    
    private func makeFAQSection() -> FormSection {
        FormSection(
            id: Tags.Section.more.rawValue,
            title: "faq.title".localized,
            cells: [] // start empty, populate after fetching
        )
    }
    
    // MARK: - Update Section
    private func updateFAQSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.more.rawValue }) else { return }

        var cells: [FormRow] = []

        for (index, item) in state.items.enumerated() {
            // Combine title and body HTML into a single string
            var htmlContent = ""
            if let titleHTML = item.title {
                htmlContent += titleHTML
            }
            if let bodyHTML = item.body {
                htmlContent += "<br><br>\(bodyHTML)" // add spacing between title and body
            }

            let row = RichDescriptionFormRow(
                tag: 1000 + index,
                model: RichDescriptionModel(
                    title: "", // title is included in HTML
                    htmlDescription: htmlContent.isEmpty ? "No content available" : htmlContent,
                    textAlignment: .left
                )
            )
            cells.append(row)

            // Spacer row
            let spacer = SpacerFormRow(tag: 2000 + index, height: 20)
            cells.append(spacer)
        }

        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }
    
    // MARK: - State
    private struct State {
        var items: [FaqItem] = []
        
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }
    
    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case more = 0
        }
    }
}
