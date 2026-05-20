//
//  ContactUsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ContactUsViewModel: FormViewModel {

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
                
                let items = try await directusService.fetchContactUs()
                state.items = items
                print("✅ Directus flow successful. Items:", items)
                
                updateContactSection()
                
            } catch {
                print("❌ Directus flow failed:", error)
            }
        }
    }
    
    // MARK: - Sections Creation
    private func makeSections() -> [FormSection] {
        sections = [
            FormSection(id: Tags.Section.more.rawValue, cells: [])
        ]
        return sections
    }
    
    // MARK: - Rows
    private func updateContactSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.more.rawValue }) else { return }

        var cells: [FormRow] = []

        for (index, item) in state.items.enumerated() {

            // Spacer before each item (optional, for breathing room)
            if index > 0 {
                let spacer = SpacerFormRow(tag: 50000 + index, height: 16)
                cells.append(spacer)
            }

            // Divider before each item (except the first)
            if index > 0 {
                let divider = DividerFormRow(tag: 40000 + index)
                cells.append(divider)
            }

            // Contact Title
            if let contactTitle = item.contactTitle {
                let titleRow = TitleDescriptionFormRow(
                    tag: 1000 + index,
                    title: contactTitle,
                    description: ""
                )
                cells.append(titleRow)
            }

            // Email Contact
            if let email = item.emailContact {
                let emailRow = TitleDescriptionFormRow(
                    tag: 2000 + index,
                    title: "Email",
                    description: email
                )
                cells.append(emailRow)
            }

            // Mobile Contact (if available)
            if let mobile = item.mobileContact {
                let mobileRow = TitleDescriptionFormRow(
                    tag: 3000 + index,
                    title: "Mobile",
                    description: mobile
                )
                cells.append(mobileRow)
            }

            // Office Location (HTML) → Use RichDescriptionFormRow
            if let officeHTML = item.officeLocation {
                let officeRow = RichDescriptionFormRow(
                    tag: 4000 + index,
                    model: RichDescriptionModel(
                        title: "Office Location",
                        htmlDescription: officeHTML,
                        maxTitleLines: 2,
                        titleFontStyle: .headline,
                        descriptionFontStyle: .body,
                        textAlignment: .left
                    )
                )
                cells.append(officeRow)
            }

            // Website
            if let website = item.website {
                let websiteRow = TitleDescriptionFormRow(
                    tag: 5000 + index,
                    title: "Website",
                    description: website
                )
                cells.append(websiteRow)
            }

            // Spacer after each item
            let spacerAfter = SpacerFormRow(tag: 6000 + index, height: 16)
            cells.append(spacerAfter)
        }

        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }
    
    // MARK: - State
    private struct State {
        var items: [ContactUsItem] = []
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
