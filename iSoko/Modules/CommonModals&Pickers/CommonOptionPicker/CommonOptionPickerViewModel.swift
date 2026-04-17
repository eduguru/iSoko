//
//  CommonOptionPickerViewModel.swift
//
//
//  Created by Edwin Weru on 23/09/2025.
//


import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

final class CommonOptionPickerViewModel: FormViewModel, ActionHandlingViewModel {

    var hasPrimaryActionButton: Bool = true
    var confirmSelection: ((CommonSelection) -> Void)? = { _ in }

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    private var commonUtilitiesService: CommonUtilitiesServiceImpl

    private var state: State

    // MARK: - Init
    init(
        option: CommonUtilityOption,
        options: [CommonIdNameModel]? = nil,
        _ commonUtilitiesService: CommonUtilitiesServiceImpl = NetworkEnvironment.shared.commonUtilitiesService
    ) {
        self.commonUtilitiesService = commonUtilitiesService
        self.state = State(commonUtilityOption: option, options: options ?? [])
        super.init()

        if options != nil {
            self.sections = makeSections()
        } else {
            fetchData()
        }
    }

    // MARK: - Fetch Data
    override func fetchData() {
        guard state.options.isEmpty else { return }

        Task {
            do {
                let response = try await fetchCommonUtility(option: state.commonUtilityOption)

                let models = mapResponse(response)

                self.state.options = models
                self.sections = makeSections()

            } catch {
                print("Error:", error)
            }
        }
    }

    // MARK: - Mapping (single switch only here)
    private func mapResponse(_ response: [Any]) -> [CommonIdNameModel] {
        switch state.commonUtilityOption {

        case .userRoles, .userTypes, .userGender, .ageGroups,
             .suppliers, .supplierCategory, .expenses, .paymentOptions:

            guard let items = response as? [CommonIdNameResponse] else { return [] }
            state.rawCommonIdNameResponse = items

            return items.map {
                CommonIdNameModel(id: $0.id, name: $0.name, description: $0.description)
            }

        case .organisationSize:
            guard let items = response as? [OrganisationSizeResponse] else { return [] }
            state.rawOrganisationSizes = items

            return items.compactMap {
                guard let id = $0.id, let name = $0.name else { return nil }
                return CommonIdNameModel(id: id, name: name, description: "")
            }

        case .organisationType:
            guard let items = response as? [OrganisationTypeResponse] else { return [] }
            state.rawOrganisationTypes = items

            return items.compactMap {
                guard let id = $0.id, let name = $0.name else { return nil }
                return CommonIdNameModel(id: id, name: name, description: "")
            }

        case .locations:
            guard let items = response as? [LocationResponse] else { return [] }
            state.rawLocationOptions = items

            return items.compactMap {
                guard let id = $0.id, let name = $0.name else { return nil }
                return CommonIdNameModel(id: id, name: name, description: $0.codeName)
            }

        case .countries:
            guard let items = response as? [CountryResponse] else { return [] }
            state.rawCountryOptions = items

            return items.compactMap {
                guard let name = $0.name else { return nil }
                return CommonIdNameModel(id: $0.id, name: name, description: $0.code)
            }
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [makeSelectionSection()]
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(id: Tags.Section.options.rawValue, cells: makeSelectionCells())
    }

    private func updateSelectionSection() {
        guard let index = sections.firstIndex(where: { $0.id == Tags.Section.options.rawValue }) else { return }
        sections[index].cells = makeSelectionCells()
        reloadSection(index)
    }

    private func makeSelectionCells() -> [FormRow] {
        state.options.map { makeOptionsRow(for: $0) }
    }

    private func makeOptionsRow(for option: CommonIdNameModel) -> SelectableRow {
        let tag = option.id.hashValue
        let isSelected = state.selectedOption?.id == option.id

        return SelectableRow(
            tag: tag,
            config: SelectableRowConfig(
                title: option.name,
                description: nil,
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: false,
                accessoryImage: nil,
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .secondarySystemGroupedBackground,
                cardBorderColor: UIColor.systemGray4,
                cardBorderWidth: 1,
                onToggle: { [weak self] selected in
                    guard let self = self, selected else { return }
                    self.state.selectedOption = option
                    self.state.selectedTag = tag
                    self.updateSelectionSection()
                }
            )
        )
    }

    // MARK: - Selection Resolver (single switch)
    private func resolveSelection(_ selected: CommonIdNameModel) -> CommonSelection {
        switch state.commonUtilityOption {

        case .locations:
            if let item = state.rawLocationOptions.first(where: { $0.id == selected.id }) {
                return .location(item)
            }

        case .organisationSize:
            if let item = state.rawOrganisationSizes.first(where: { $0.id == selected.id }) {
                return .organisationSize(item)
            }

        case .organisationType:
            if let item = state.rawOrganisationTypes.first(where: { $0.id == selected.id }) {
                return .organisationType(item)
            }

        case .countries:
            
            if let item = state.rawCountryOptions.first(where: { $0.id == selected.id }) {
                return .countries(item)
            }

        default:
            return .idName(selected)
        }

        return .idName(selected)
    }

    // MARK: - Confirm Button
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
            guard let self = self,
                  let selected = self.state.selectedOption else { return }

            self.confirmSelection?(self.resolveSelection(selected))
        }
    )

    // MARK: - ActionHandling
    func handlePrimaryAction() {
        guard let selected = state.selectedOption else { return }
        confirmSelection?(resolveSelection(selected))
    }

    // MARK: - State
    private struct State {
        var options: [CommonIdNameModel]
        var selectedOption: CommonIdNameModel?

        var rawLocationOptions: [LocationResponse] = []
        var rawCountryOptions: [CountryResponse] = []
        var rawOrganisationSizes: [OrganisationSizeResponse] = []
        var rawOrganisationTypes: [OrganisationTypeResponse] = []
        var rawCommonIdNameResponse: [CommonIdNameResponse] = []

        var selectedTag: Int?
        var commonUtilityOption: CommonUtilityOption

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        init(commonUtilityOption: CommonUtilityOption, options: [CommonIdNameModel]) {
            self.commonUtilityOption = commonUtilityOption
            self.options = options
        }
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case options = 1
            case confirmation = 2
        }
    }
}

// MARK: - API Fetching
extension CommonOptionPickerViewModel {
    func fetchCommonUtility(option: CommonUtilityOption) async throws -> [Any] {
        switch option {
        case let .userRoles(page, count):
            return try await commonUtilitiesService.getUserRoles(page: page, count: count, accessToken: state.guestToken)
        case let .userTypes(page, count):
            return try await commonUtilitiesService.getUserTypes(page: page, count: count, accessToken: state.guestToken)
        case let .userGender(page, count):
            return try await commonUtilitiesService.getUserGender(page: page, count: count, accessToken: state.guestToken)
        case let .organisationType(page, count):
            return try await commonUtilitiesService.getOrganisationType(page: page, count: count, accessToken: state.guestToken)
        case let .organisationSize(page, count):
            return try await commonUtilitiesService.getOrganisationSize(page: page, count: count, accessToken: state.guestToken)
        case .ageGroups:
            return try await commonUtilitiesService.getUserAgeGroups(accessToken: state.guestToken)
        case let .locations(page, count):
            return try await commonUtilitiesService.getAllLocations(page: page, count: count, accessToken: state.guestToken)
        case let .countries(page, count):
            return try await commonUtilitiesService.getSystemCountries(page: page, count: count, accessToken: state.guestToken).data
        
        case .suppliers(page: let page, count: let count):
            return try await bookKeepingService.getSupplierCategories(page: page, count: count, accessToken: state.oauthToken).data
        case .supplierCategory(page: let page, count: let count):
            return try await bookKeepingService.getSupplierCategories(page: page, count: count, accessToken: state.oauthToken).data
            
        case .expenses(page: let page, count: let count):
            return try await bookKeepingService.getExpenseCategories(page: page, count: count, accessToken: state.oauthToken).data
        
        case .paymentOptions(page: let page, count: let count):
            return try await commonUtilitiesService.getPaymentOptions(page: page, count: count, accessToken: state.oauthToken).data
         
        }
    }
}
