//
//  CommodityPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 19/04/2026.
//

import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

final class CommodityPickerViewModel: FormViewModel, ActionHandlingViewModel {
    
    var hasPrimaryActionButton: Bool = true
    var confirmSelection: ((CommonSelection) -> Void)?
    
    // MARK: - Services
    private let service: CommonUtilitiesServiceImpl
    
    // MARK: - State
    private var state = State()
    
    // MARK: - Init
    init(service: CommonUtilitiesServiceImpl = NetworkEnvironment.shared.commonUtilitiesService) {
        self.service = service
        super.init()
        
        setupInitialSections()
        fetchCategories()
    }
}

// MARK: - Setup Sections
extension CommodityPickerViewModel {
    
    private func setupInitialSections() {
        sections = [
            FormSection(
                id: Tags.Section.categories.rawValue,
                title: "Categories",
                cells: []
            ),
            FormSection(
                id: Tags.Section.commodities.rawValue,
                title: "Commodities",
                cells: []
            )
        ]
    }
}

// MARK: - Fetching
extension CommodityPickerViewModel {
    
    func fetchCategories() {
        showLoader()
        
        Task {
            do {
                let response = try await service.getCommodityCategory(
                    page: state.currentPage,
                    count: state.itemsPerPage,
                    module: "",
                    accessToken: state.token
                )
                
                state.categories = response
                updateCategoriesSection()
                hideLoader()
                
            } catch {
                hideLoader()
                print("Categories error:", error)
            }
        }
    }
    
    func fetchCommodities(categoryId: Int) {
        showLoader()
        
        Task {
            do {
                let response = try await service.getCommoditiesV1(
                    page: 1,
                    count: 50,
                    categoryId: "\(categoryId)",
                    subCategoryId: "",
                    accessToken: state.token
                )
                
                state.commodities = response.data
                updateCommoditiesSection()
                hideLoader()
                
            } catch {
                hideLoader()
                print("Commodities error:", error)
            }
        }
    }
}

// MARK: - Section Updates
extension CommodityPickerViewModel {
    
    private func updateCategoriesSection() {
        guard let index = sections.firstIndex(where: { $0.id == Tags.Section.categories.rawValue }) else { return }
        
        sections[index].cells = state.categories.map { makeCategoryRow($0) }
        reloadSection(index)
    }
    
    private func updateCommoditiesSection() {
        guard let index = sections.firstIndex(where: { $0.id == Tags.Section.commodities.rawValue }) else { return }
        
        sections[index].cells = state.commodities.map { makeCommodityRow($0) }
        reloadSection(index)
    }
}

// MARK: - Rows
extension CommodityPickerViewModel {
    
    private func makeCategoryRow(_ item: CommodityCategoryResponse) -> SelectableRow {
        let isSelected = state.selectedCategory?.id == item.id
        
        return SelectableRow(
            tag: item.id ?? 0,
            config: .init(
                title: item.name ?? "",
                description: nil,
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
                guard let self, selected, let id = item.id else { return }
                
                // Update selection
                self.state.selectedCategory = item
                self.state.selectedCommodity = nil
                
                // Clear old commodities immediately (better UX)
                self.state.commodities = []
                self.updateCommoditiesSection()
                
                // Fetch new commodities
                self.fetchCommodities(categoryId: id)
                
                // Refresh categories to reflect selection state
                self.updateCategoriesSection()
            }
        )
    }
    
    private func makeCommodityRow(_ item: CommodityV1Response) -> SelectableRow {
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
extension CommodityPickerViewModel {
    
    func handlePrimaryAction() {
        if let commodity = state.selectedCommodity {
            confirmSelection?(.commodities(commodity))
        } else if let category = state.selectedCategory {
            confirmSelection?(.commodityCategories(category))
        }
    }
}

// MARK: - State
extension CommodityPickerViewModel {
    
    private struct State {
        var categories: [CommodityCategoryResponse] = []
        var commodities: [CommodityV1Response] = []
        
        var selectedCategory: CommodityCategoryResponse?
        var selectedCommodity: CommodityV1Response?
        
        var currentPage = 1
        var itemsPerPage = 20
        
        var token: String {
            AppStorage.oauthToken?.accessToken ?? ""
        }
    }
}

// MARK: - Tags
extension CommodityPickerViewModel {
    
    enum Tags {
        enum Section: Int {
            case categories = 0
            case commodities = 1
        }
    }
}
