//
//  CountryLanguagePreferenceViewModel.swift
//
//
//  Created by Edwin Weru on 16/09/2025.
//

import DesignSystemKit
import UIKit

final class CountryLanguagePreferenceViewModel: FormViewModel {
    var gotoSelectCountry: (() -> Void)? = { }
    var gotoSelectLanguage: (() -> Void)? = { }
    var gotoConfirm: (() -> Void)? = { }
    
    private var state: State?
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeBodySection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                imageRow,
                headerTitleRow,
                SpacerFormRow(tag: 1001),
            ]
        )
    }
    
    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            title: nil,
            cells: [countryRow, languageRow, SpacerFormRow(tag: -1), buttonRow]
        )
    }
    
    // MARK: - make rows
    private  lazy var imageRow = ImageFormRow(
        tag: 1001,
        image: UIImage(named: "user"),
        height: 120
    )
    
    private lazy var headerTitleRow = TitleDescriptionFormRow(
        tag: 101,
        title: "Welcome to the app",
        description: "This description",
        maxTitleLines: 2,
        maxDescriptionLines: 0,  // unlimited lines
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .center
    )
    
    private lazy var buttonRow = ButtonFormRow(
        tag: 1001,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )
    
    private lazy var countryRow = DropdownFormRow(
        tag: 3001,
        config: DropdownFormConfig(
            title: "Select Country",
            placeholder: "Country",
            leftImage: nil,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.gotoSelectCountry?()
            }
        )
    )
    
    private lazy var languageRow = DropdownFormRow(
        tag: 3001,
        config: DropdownFormConfig(
            title: "Select Language",
            placeholder: "Language",
            leftImage: nil,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.gotoSelectLanguage?()
            }
        )
    )
    
    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
            // Handle header taps here
        case Tags.Section.body.rawValue:
            print("Credentials section row selected: \(row.tag)")
            // Handle credentials taps here
        default:
            break
        }
    }
    
    
    private struct State {
        var language: String?
        var country: String?
    }
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
        
        enum Cells: Int {
            case signIn = 0
            case headerImage = 1
            case headerTitle = 2
        }
    }
}
