//
//  FilterOptionPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 09/09/2026.
//

import DesignSystemKit
import UIKit
import StorageKit

@MainActor
final class FilterOptionPickerViewModel: FormViewModel {

    // MARK: - Output
    var onSelected: ((CommonIdNameModel?) -> Void)?

    // MARK: - Services
    private let commonUtilitiesService = NetworkEnvironment.shared.commonUtilitiesService
    private let associationsService = NetworkEnvironment.shared.associationsService

    // MARK: - State
    private var state = State()

    // MARK: - Init
    init(option: FilterPickerOption) {
        state.option = option
        super.init()
        sections = makeSections()
    }

    // MARK: - Fetch
    override func fetchData() {
        Task { await loadOptions() }
    }

    private func loadOptions() async {
        showLoader()
        defer { hideLoader() }

        do {
            switch state.option {
            case .category:
                let result = try await commonUtilitiesService.getCommodityCategory(
                    page: 1, count: 100,
                    module: "",
                    accessToken: state.guestToken
                )
                state.items = result.compactMap {
                    guard let id = $0.id, let name = $0.name else { return nil }
                    return CommonIdNameModel(id: id, name: name)
                }

            case .association:
                let result = try await associationsService.getAllAssociations(
                    page: 1, count: 100,
                    accessToken: state.oauthToken
                )
                state.items = result.compactMap {
                    guard let id = $0.id, let name = $0.name else { return nil }
                    return CommonIdNameModel(id: id, name: name)
                }

            case .location:
                let result = try await commonUtilitiesService.getAllLocations(
                    page: 1, count: 100,
                    accessToken: state.guestToken
                ).data
                state.items = result.compactMap {
                    guard let name = $0.name else { return nil }
                    return CommonIdNameModel(id: $0.id ?? -1, name: name)
                }

            case .static(let options):
                state.items = options
            }

            reloadOptionsSection()

        } catch {
            print("❌ FilterOptionPickerViewModel error:", error)
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(id: SectionTag.options.rawValue, cells: [])
        ]
    }

    private func reloadOptionsSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.options.rawValue
        }) else { return }

        sections[index].cells = makeOptionRows()
        reloadSection(index)
    }

    private func makeOptionRows() -> [FormRow] {
        state.items.enumerated().map { index, item in
            SelectableRow(
                tag: 3000 + index,
                config: SelectableRowConfig(
                    title: item.name,
                    description: item.description,
                    isSelected: state.selectedItem?.id == item.id,
                    selectionStyle: .radio,
                    isAccessoryVisible: false,
                    isCardStyleEnabled: true,
                    cardCornerRadius: 12,
                    cardBackgroundColor: .secondarySystemGroupedBackground,
                    cardBorderColor: .systemGray4,
                    cardBorderWidth: 1,
                    onToggle: { [weak self] selected in
                        guard let self, selected else { return }
                        self.state.selectedItem = item
                        self.reloadOptionsSection()
                        self.onSelected?(item)
                    }
                )
            )
        }
    }

    // MARK: - State
    private struct State {
        var option: FilterPickerOption = .static([])
        var items: [CommonIdNameModel] = []
        var selectedItem: CommonIdNameModel? = nil
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
    }

    private enum SectionTag: Int {
        case options = 0
    }
}

enum FilterPickerOption {
    case category
    case association
    case location
    case `static`([CommonIdNameModel])
}
