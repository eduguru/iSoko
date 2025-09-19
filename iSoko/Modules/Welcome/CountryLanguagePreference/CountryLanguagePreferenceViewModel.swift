//
//  CountryLanguagePreferenceViewModel.swift
//
//
//  Created by Edwin Weru on 16/09/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class CountryLanguagePreferenceViewModel: FormViewModel {
    
    var gotoSelectCountry: (_ completion: @escaping (Country?) -> Void) -> Void = { _ in }
    var gotoSelectLanguage: (_ completion: @escaping (Language?) -> Void) -> Void = { _ in }
    var gotoConfirm: (() -> Void)? = { }

    private var state: State?

    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        return [
            makeHeaderSection(),
            makeBodySection()
        ]
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
            cells: [
                countryRow,
                languageRow,
                SpacerFormRow(tag: -1),
                buttonRow
            ]
        )
    }

    // MARK: - UI Rows

    private lazy var imageRow = ImageFormRow(
        tag: 1001,
        image: UIImage(named: "logo"),
        height: 120
    )

    private lazy var headerTitleRow = TitleDescriptionFormRow(
        tag: 101,
        title: "Welcome to the app",
        description: "This description",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
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

    // MARK: - Country Row

    private lazy var countryRow = makeCountryRow()

    private func makeCountryRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: 3001,
            config: DropdownFormConfig(
                title: "Select Country",
                placeholder: state?.country?.name ?? "Country",
                leftImage: nil,
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.handleCountrySelection()
                }
            )
        )
    }

    private func handleCountrySelection() {
        gotoSelectCountry { [weak self] selectedCountry in
            guard let self = self, let selectedCountry = selectedCountry else { return }

            self.state?.country = selectedCountry
            self.countryRow.config.placeholder = selectedCountry.name
            self.reloadRowWithTag(self.countryRow.tag)
        }
    }

    // MARK: - Language Row

    private lazy var languageRow = makeLanguageRow()

    private func makeLanguageRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: 3002,
            config: DropdownFormConfig(
                title: "Select Language",
                placeholder: state?.language?.name ?? "Language",
                leftImage: nil,
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.handleLanguageSelection()
                }
            )
        )
    }

    private func handleLanguageSelection() {
        gotoSelectLanguage { [weak self] selectedLanguage in
            guard let self = self, let selectedLanguage = selectedLanguage else { return }

            self.state?.language = selectedLanguage
            self.languageRow.config.placeholder = selectedLanguage.name
            self.reloadRowWithTag(self.languageRow.tag)
        }
    }

    // MARK: - Helpers

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }

    // MARK: - Selection Override

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
        case Tags.Section.body.rawValue:
            print("Body section row selected: \(row.tag)")
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var language: Language?
        var country: Country?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
            case country = 2
            case language = 3
            case confirm = 4
        }
    }
}
