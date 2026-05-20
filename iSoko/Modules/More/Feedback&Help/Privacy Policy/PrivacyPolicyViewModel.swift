//
//  PrivacyPolicyViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class PrivacyPolicyViewModel: FormViewModel {
    
    // MARK: - Internal state
    private var state: State
    private let directusService = DirectusTokenService()
    
    // MARK: - Initialization
    override init() {
        state = State()
        super.init()
        sections = makeSections()
    }
    
    override func refresh() {
        fetchData()
    }
    
    override func fetchData() {
        showLoader()
        defer { hideLoader() }
        
        Task {
            do {
                try await directusService.login(
                    email: AppStorage.email,
                    password: AppStorage.password
                )
                
                let items = try await directusService.fetchPrivacyPolicy()
                state.items = items
                print("✅ Directus flow successful. Items:", items)
                
                updatePrivacySection()
                
            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }
    
    // MARK: - Sections Creation
    private func makeSections() -> [FormSection] {
        // Initialize with empty section
        sections = [
            FormSection(id: Tags.Section.more.rawValue, cells: [])
        ]
        return sections
    }
    
    // MARK: - Rows
    private func updatePrivacySection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.more.rawValue }) else { return }
        
        var cells: [FormRow] = []
        
        for (index, item) in state.items.enumerated() {
            let richRow = RichDescriptionFormRow(
                tag: 1000 + index,
                model: RichDescriptionModel(
                    title: nil, // No title, only content
                    htmlDescription: item.content ?? "",
                    maxTitleLines: 2,
                    titleFontStyle: .headline,
                    descriptionFontStyle: .body,
                    textAlignment: .left
                )
            )
            cells.append(richRow)
            
            // Add spacer between items
            let spacer = SpacerFormRow(tag: 2000 + index, height: 16)
            cells.append(spacer)
        }
        
        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }
    
    // MARK: - State
    private struct State {
        var items: [PrivacyPolicyItem] = []
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
