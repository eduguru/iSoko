//
//  CountryPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 17/09/2025.
//

import DesignSystemKit
import UtilsKit
import UIKit

final class CountryPickerViewModel: FormViewModel {
    var confirmSelection: ((Country) -> Void)? = { _ in }

    private var state: State?

    override init() {
        self.state = State()
        super.init()

        self.sections = makeSections()
    }

    // MARK: - Section Builders

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(FormSection(id: Tags.Section.header.rawValue, title: nil, cells: [makeHeaderTitleRow()]))
        sections.append(makeSelectionSection())
        sections.append(FormSection(id: Tags.Section.confirmation.rawValue, title: nil, cells: [confirmButtonRow]))

        return sections
    }

    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Select Region",
            description: "Please Select your country or region",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
        
        return row
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(id: Tags.Section.transactions.rawValue, cells: makeSelectionCells())
    }
    
    private func updateSelectionSection() {
        guard let sectionIndex = sections.firstIndex( where: { $0.id == Tags.Section.transactions.rawValue }) else { return }
        let cells = makeSelectionCells()
        
        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }

    private func makeSelectionCells() -> [FormRow] {
        let countries = countries()
        return countries.map { makeCountryRow(for: $0) }
    }

    // MARK: - Row Builders

    private func makeCountryRow(for country: Country) -> SelectableRow {
        let tag = tag(for: country)
        let isSelected: Bool = state?.selectedCountry?.id == country.id ? true : false

        return SelectableRow(
            tag: tag,
            config: SelectableRowConfig(
                title: country.name,
                description: nil,
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: true,
                accessoryImage: UIImage.fromEmoji(country.flag),
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .secondarySystemGroupedBackground,
                cardBorderColor: UIColor.systemGray4,
                cardBorderWidth: 1,
                onToggle: { [weak self] selected in
                    guard let self = self else { return }

                    if selected {
                        self.state?.selectedCountry = country
                        self.state?.selectedTag = tag
                        self.updateSelectionSection()
                    }
                }
            )
        )
    }


    // MARK: - Button Row

    lazy var confirmButtonRow = ButtonFormRow(
        tag: 9999,
        model: ButtonFormModel(
            title: "Confirm",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }
            guard let selectedCountry = self.state?.selectedCountry else { return }

            self.confirmSelection?(selectedCountry)
        }
    )

    // MARK: - Helpers

    private func tag(for country: Country) -> Int {
        return country.id.hashValue
    }

    private var selectedCountries: [Country] {
        let selectedCodes = state?.selectedCountryCodes ?? []
        return countries().filter { selectedCodes.contains($0.id) }
    }

    // MARK: - Selection Handling (optional override)
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
        case Tags.Section.transactions.rawValue:
            print("Credentials section row selected: \(row.tag)")
        default:
            break
        }
    }
    
    // MARK: - Country Data
    private func countries() -> [Country] {
        let helper = CountryHelper()

        state?.countries = helper.countries
        return state?.countries ?? []
    }

    // MARK: - State

    private struct State {
        var selectedCountryCodes: Set<String> = []
        var countries: [Country] = []
        var selectedCountry: Country?
        var searchText: String = ""
        var selectedTag: Int?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case transactions = 1
            case confirmation = 2
        }

        enum Cells: Int {
            case search = 0
            case ceountry = 1
            case comfirm = 2
        }
    }
}
