//
//  CountryPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 17/09/2025.
//

import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

@MainActor
final class CountryPickerViewModel: FormViewModel, ActionHandlingViewModel {

    var hasPrimaryActionButton: Bool = true
    var confirmSelection: ((Country) -> Void)? = { _ in }

    private let commonUtilitiesService: CommonUtilitiesServiceImpl
    private var state = State()

    init(
        commonUtilitiesService: CommonUtilitiesServiceImpl = NetworkEnvironment.shared.commonUtilitiesService
    ) {
        self.commonUtilitiesService = commonUtilitiesService
        super.init()

        sections = makeSections()
        fetchData()
    }

    override func fetchData() {
        showLoader()

        Task { @MainActor in
            defer { hideLoader() }

            do {
                let token = AppStorage.guestToken?.accessToken ?? ""

                let response = try await commonUtilitiesService.getSystemCountries(
                    page: 1,
                    count: 500,
                    accessToken: token
                ).data

                state.countries = makeCountries(from: []) // use local countries
                // state.countries = makeCountries(from: response)
            } catch {
                print("Failed to fetch countries:", error)
                state.countries = makeCountries(from: [])
            }

            sections = makeSections()
        }
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.header.rawValue,
                title: nil,
                cells: [makeHeaderTitleRow()]
            ),
            makeSelectionSection()
        ]
    }

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: 101,
            model: TitleDescriptionModel(
                title: "common.select_region".localized,
                description: "common.select_region_desc".localized,
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .title,
                descriptionFontStyle: .subheadline
            )
        )
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(
            id: Tags.Section.countries.rawValue,
            cells: makeSelectionCells()
        )
    }

    private func updateSelectionSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.countries.rawValue }) else {
            return
        }

        sections[sectionIndex].cells = makeSelectionCells()
        reloadSection(sectionIndex)
    }

    private func makeSelectionCells() -> [FormRow] {
        state.countries.map { makeCountryRow(for: $0) }
    }

    // MARK: - Rows

    private func makeCountryRow(for country: Country) -> SelectableRow {
        let tag = country.id.hashValue
        let isSelected = state.selectedCountry?.id == country.id

        return SelectableRow(
            tag: tag,
            config: SelectableRowConfig(
                title: country.name,
                // description: country.phoneCode,
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
                    guard let self, selected else { return }

                    self.state.selectedCountry = country
                    self.state.selectedTag = tag
                    self.updateSelectionSection()
                }
            )
        )
    }

    // MARK: - Primary Action

    func handlePrimaryAction() {
        guard let selectedCountry = state.selectedCountry else { return }
        confirmSelection?(selectedCountry)
    }

    // MARK: - Mapping

    private func makeCountries(from responseCountries: [CountryResponse]) -> [Country] {
        let helper = CountryHelper()
        let allLocalCountries = helper.allCountries

        guard !responseCountries.isEmpty else {
            return helper.countries
        }

        let mappedCountries = responseCountries.compactMap { response -> Country? in
            guard let rawCode = response.code?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !rawCode.isEmpty else {
                return nil
            }

            let iso = rawCode.uppercased()
            let localCountry = allLocalCountries.first { $0.id == iso }

            return Country(
                id: iso,
                name: response.name ?? localCountry?.name ?? iso,
                phoneCode: localCountry?.phoneCode ?? "",
                continentCode: localCountry?.continentCode
            )
        }

        return mappedCountries.isEmpty ? helper.countries : mappedCountries
    }

    // MARK: - State

    private struct State {
        var countries: [Country] = []
        var selectedCountry: Country?
        var selectedTag: Int?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case countries = 1
        }
    }
}
