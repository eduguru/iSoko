//
//  CommodityOnlyPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 01/07/2026.
//

import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

@MainActor
final class CommodityOnlyPickerViewModel: FormViewModel, ActionHandlingViewModel {

    var hasPrimaryActionButton: Bool = true
    var confirmSelection: ((CommonSelection) -> Void)?

    // MARK: - Services

    private let service: CommonUtilitiesServiceImpl

    // MARK: - State

    private var state = State()

    // MARK: - Init

    init(
        service: CommonUtilitiesServiceImpl = NetworkEnvironment.shared.commonUtilitiesService
    ) {
        self.service = service
        super.init()

        setupSections()
        fetchCommodities()
    }
}

// MARK: - Setup

private extension CommodityOnlyPickerViewModel {

    func setupSections() {
        sections = [
            FormSection(
                id: Tags.Section.commodities.rawValue,
                title: "common.label.commodities".localized,
                cells: []
            )
        ]
    }
}

// MARK: - Fetching

private extension CommodityOnlyPickerViewModel {

    func fetchCommodities() {

        showLoader()

        Task {
            defer { hideLoader() }

            do {

                let response = try await service.getCommoditiesV1(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    categoryId: "",
                    subCategoryId: "",
                    accessToken: state.token
                )

                state.commodities = response.data
                updateCommoditiesSection()

            } catch {
                print("Commodities error:", error)
            }
        }
    }
}

// MARK: - Section Updates

private extension CommodityOnlyPickerViewModel {

    func updateCommoditiesSection() {

        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.commodities.rawValue
        }) else {
            return
        }

        sections[index].cells = state.commodities.map(makeCommodityRow)

        reloadSection(index)
    }
}

// MARK: - Rows

private extension CommodityOnlyPickerViewModel {

    func makeCommodityRow(_ item: CommodityV1Response) -> SelectableRow {

        let isSelected = state.selectedCommodity?.id == item.id

        return SelectableRow(
            tag: item.id ?? 0,
            config: .init(
                title: item.name ?? "",
                description: item.marketPriceUnit?.name ?? "",
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: false,
                accessoryImage: nil,
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .secondarySystemGroupedBackground,
                cardBorderColor: .systemGray4,
                cardBorderWidth: 1
            ) { [weak self] selected in

                guard let self, selected else { return }

                self.state.selectedCommodity = item
                self.updateCommoditiesSection()
            }
        )
    }
}

// MARK: - Actions

extension CommodityOnlyPickerViewModel {

    func handlePrimaryAction() {

        guard let commodity = state.selectedCommodity else {
            showError("Please select a commodity")
            return
        }

        confirmSelection?(.commodities(commodity))
    }
}

// MARK: - State

private extension CommodityOnlyPickerViewModel {

    struct State {

        var commodities: [CommodityV1Response] = []

        var selectedCommodity: CommodityV1Response?

        var currentPage = 1
        var itemsPerPage = 50

        var token: String {
            AppStorage.oauthToken?.accessToken ?? ""
        }
    }
}

// MARK: - Tags

extension CommodityOnlyPickerViewModel {

    enum Tags {

        enum Section: Int {
            case commodities = 0
        }
    }
}
