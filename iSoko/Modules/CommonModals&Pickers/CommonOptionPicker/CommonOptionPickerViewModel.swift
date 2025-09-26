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
        guard state.options.isEmpty else {
            print("✅ Skipping API fetch — using provided options.")
            return
        }

        Task {
            do {
                let response = try await fetchCommonUtility(option: state.commonUtilityOption)
                let models: [CommonIdNameModel]

                switch state.commonUtilityOption {
                case .userRoles, .userTypes, .userGender, .ageGroups:
                    guard let items = response as? [CommonIdNameResponse] else {
                        print("⚠️ Unexpected response type for CommonIdNameResponse")
                        return
                    }

                    switch state.commonUtilityOption {
                    case .userRoles: state.rawUserRoles = items
                    case .userTypes: state.rawUserTypes = items
                    case .userGender: state.rawGenders = items
                    case .ageGroups: state.rawAgeGroups = items
                    default: break
                    }

                    models = items.map {
                        CommonIdNameModel(id: $0.id, name: $0.name, description: $0.description)
                    }

                case .organisationSize:
                    guard let items = response as? [OrganisationSizeResponse] else { return }
                    state.rawOrganisationSizes = items
                    models = items.compactMap {
                        guard let id = $0.id, let name = $0.name else { return nil }
                        return CommonIdNameModel(id: id, name: name, description: "")
                    }

                case .organisationType:
                    guard let items = response as? [OrganisationTypeResponse] else { return }
                    state.rawOrganisationTypes = items
                    models = items.compactMap {
                        guard let id = $0.id, let name = $0.name else { return nil }
                        return CommonIdNameModel(id: id, name: name, description: "")
                    }

                case .locations:
                    guard let items = response as? [LocationResponse] else { return }
                    state.rawLocationOptions = items
                    models = items.compactMap {
                        guard let id = $0.id, let name = $0.name else { return nil }
                        return CommonIdNameModel(id: id, name: name, description: $0.codeName)
                    }
                }

                self.state.options = models
                self.sections = makeSections()

            } catch let NetworkError.server(apiError) {
                print("API error:", apiError.message ?? "")
            } catch {
                print("Unexpected error:", error)
            }
        }
    }

    // MARK: - Section Builders

    private func makeSections() -> [FormSection] {
        return [makeSelectionSection()]
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(id: Tags.Section.options.rawValue, cells: makeSelectionCells())
    }

    private func updateSelectionSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.options.rawValue }) else { return }
        sections[sectionIndex].cells = makeSelectionCells()
        reloadSection(sectionIndex)
    }

    private func makeSelectionCells() -> [FormRow] {
        return state.options.map { makeOptionsRow(for: $0) }
    }

    private func makeOptionsRow(for option: CommonIdNameModel) -> SelectableRow {
        let tag = tag(for: option)
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
                    guard let self = self else { return }
                    if selected {
                        self.state.selectedOption = option
                        self.state.selectedTag = tag
                        self.updateSelectionSection()
                    }
                }
            )
        )
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
            guard let self = self else { return }
            guard let selected = self.state.selectedOption else { return }

            switch self.state.commonUtilityOption {
            case .locations:
                if let location = self.state.rawLocationOptions.first(where: { $0.id == selected.id }) {
                    self.confirmSelection?(.location(location))
                }
            case .organisationSize:
                if let size = self.state.rawOrganisationSizes.first(where: { $0.id == selected.id }) {
                    self.confirmSelection?(.organisationSize(size))
                }
            case .organisationType:
                if let type = self.state.rawOrganisationTypes.first(where: { $0.id == selected.id }) {
                    self.confirmSelection?(.organisationType(type))
                }
            default:
                self.confirmSelection?(.idName(selected))
            }
        }
    )

    // MARK: - Helpers

    private func tag(for option: CommonIdNameModel) -> Int {
        return option.id.hashValue
    }

    public func getOptions() -> [CommonIdNameModel] {
        return state.options
    }

    // MARK: - Selection Handling

    func handlePrimaryAction() {
        guard let selected = self.state.selectedOption else { return }

        switch self.state.commonUtilityOption {
        case .locations:
            if let location = self.state.rawLocationOptions.first(where: { $0.id == selected.id }) {
                self.confirmSelection?(.location(location))
            }
        case .organisationSize:
            if let size = self.state.rawOrganisationSizes.first(where: { $0.id == selected.id }) {
                self.confirmSelection?(.organisationSize(size))
            }
        case .organisationType:
            if let type = self.state.rawOrganisationTypes.first(where: { $0.id == selected.id }) {
                self.confirmSelection?(.organisationType(type))
            }
        default:
            self.confirmSelection?(.idName(selected))
        }
    }

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
        case Tags.Section.options.rawValue:
            print("Options section row selected: \(row.tag)")
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var options: [CommonIdNameModel]
        var selectedOption: CommonIdNameModel?

        // Raw API data
        var rawLocationOptions: [LocationResponse] = []
        var rawOrganisationSizes: [OrganisationSizeResponse] = []
        var rawOrganisationTypes: [OrganisationTypeResponse] = []
        var rawUserRoles: [CommonIdNameResponse] = []
        var rawUserTypes: [CommonIdNameResponse] = []
        var rawGenders: [CommonIdNameResponse] = []
        var rawAgeGroups: [CommonIdNameResponse] = []

        var selectedTag: Int?
        var commonUtilityOption: CommonUtilityOption
        var accessToken: String = AppStorage.accessToken ?? ""

        init(commonUtilityOption: CommonUtilityOption, options: [CommonIdNameModel] = []) {
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

        enum Cells: Int {
            case search = 0
            case option = 1
            case confirm = 2
        }
    }
}

// MARK: - API Fetching
extension CommonOptionPickerViewModel {
    func fetchCommonUtility(option: CommonUtilityOption) async throws -> [Any] {
        switch option {
        case let .userRoles(page, count):
            return try await commonUtilitiesService.getUserRoles(page: page, count: count, accessToken: state.accessToken)
        case let .userTypes(page, count):
            return try await commonUtilitiesService.getUserTypes(page: page, count: count, accessToken: state.accessToken)
        case let .userGender(page, count):
            return try await commonUtilitiesService.getUserGender(page: page, count: count, accessToken: state.accessToken)
        case let .organisationType(page, count):
            return try await commonUtilitiesService.getOrganisationType(page: page, count: count, accessToken: state.accessToken)
        case let .organisationSize(page, count):
            return try await commonUtilitiesService.getOrganisationSize(page: page, count: count, accessToken: state.accessToken)
        case .ageGroups:
            return try await commonUtilitiesService.getUserAgeGroups(accessToken: state.accessToken)
        case let .locations(page, count):
            return try await commonUtilitiesService.getAllLocations(page: page, count: count, accessToken: state.accessToken)
        }
    }
}
