//
//  HomeViewModel.swift
//
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class HomeViewModel: FormViewModel {
    
    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    private let servicesService = NetworkEnvironment.shared.servicesService
    private let commonUtilitiesService = NetworkEnvironment.shared.commonUtilitiesService
    
    // MARK: - State
    private var state: State?
    
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let categoriesSuccess = await fetchCategories()
            let featuredSuccess = await fetchFeaturedItems()
            
            if !categoriesSuccess {
                print("⚠️ Failed to fetch one or more category types.")
            }
            
            if !featuredSuccess {
                print("⚠️ Failed to fetch one or more featured item types.")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateProductCategoriesSection()
                self.updateServiceCategoriesSection()
                self.updateTrendingProductsSection()
                self.updateTrendingServicesSection()
            }
        }
    }
    
    private func fetchCategories() async -> Bool {
        async let productCategories = fetchData(type: .productCategories)
        async let serviceCategories = fetchData(type: .serviceCategories)
        
        let results = await [productCategories, serviceCategories]
        return results.allSatisfy { $0 }
    }
    
    private func fetchFeaturedItems() async -> Bool {
        async let featuredProducts = fetchData(type: .featuredProducts)
        async let featuredServices = fetchData(type: .featuredServices)
        
        let results = await [featuredProducts, featuredServices]
        return results.allSatisfy { $0 }
    }
    
    @discardableResult
    private func fetchData(type: HomeDataType) async -> Bool {
        do {
            switch type {
            case .featuredProducts:
                let response = try await productsService.getFeaturedProducts(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.featuredProducts = response
                print("✅ Fetched Featured Products")
                
            case .featuredServices:
                let response = try await servicesService.getFeaturedTradeServices(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.featuredServices = response
                print("✅ Fetched Featured Services")
                
            case .productCategories:
                let response = try await commonUtilitiesService.getCommodityCategory(
                    page: 1, count: 20, module: "<regulation | trade-documents | standards>", accessToken: state?.accessToken ?? "")
                self.state?.productCategories = response
                print("✅ Fetched Product Categories")
                
            case .serviceCategories:
                let response = try await servicesService.getAllTradeServiceCategories(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.serviceCategories = response
                print("✅ Fetched Service Categories")
            }
            return true
            
        } catch let NetworkError.server(apiError) {
            print("❌ API Error in \(type):", apiError.message ?? "")
        } catch {
            print("❌ Unexpected Error in \(type):", error)
        }
        return false
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        return [
            FormSection(id: Tags.Section.search.rawValue, title: nil, cells: [searchRow]),
            makeCategoriesQuickActionsSection(),
            makeServicesQuickActionsSection(),
            makeBannerSection(),
            makeTrendingProductsSection(),
            makeTrendingServicesSection()
        ]
    }
    
    private func makeCategoriesQuickActionsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.categories.rawValue,
            title: "Explore Categories",
            cells: [productCategoriesFormRow]
        )
    }
    
    private func makeServicesQuickActionsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.serviceCategories.rawValue,
            title: "Explore Service Categories",
            cells: [tradeServiceCategoriesFormRow]
        )
    }
    
    private func makeBannerSection() -> FormSection {
        return FormSection(
            id: Tags.Section.banner.rawValue,
            title: nil,
            cells: [bannerRow]
        )
    }
    
    private func makeTrendingProductsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.trendingProducts.rawValue,
            title: "Trending Products",
            cells: [trendingProducts]
        )
    }
    
    private func makeTrendingServicesSection() -> FormSection {
        return FormSection(
            id: Tags.Section.trendingServices.rawValue,
            title: "Trending Services",
            cells: [trendingServices]
        )
    }

    // MARK: - Update Sections

    private func updateProductCategoriesSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.categories.rawValue }) else {
            return
        }
        let updatedRow = QuickActionsFormRow(
            tag: Tags.Cells.categories.rawValue,
            items: makeProductCategoryItems()
        )
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    private func updateServiceCategoriesSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.serviceCategories.rawValue }) else {
            return
        }
        let updatedRow = QuickActionsFormRow(
            tag: Tags.Cells.serviceCategories.rawValue,
            items: makeServiceCategoryItems()
        )
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    private func updateTrendingProductsSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.trendingProducts.rawValue }) else {
            return
        }
        let updatedRow = GridFormRow(
            tag: Tags.Cells.trendingProducts.rawValue,
            items: makeTrendingProductItems(),
            numberOfColumns: 2,
            useCollectionView: false
        )
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    private func updateTrendingServicesSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.trendingServices.rawValue }) else {
            return
        }
        let updatedRow = GridFormRow(
            tag: Tags.Cells.trendingServices.rawValue,
            items: makeTrendingServiceItems(),
            numberOfColumns: 2,
            useCollectionView: false
        )
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    // MARK: - Form Rows
    
    lazy var searchRow = SearchFormRow(
        tag: Tags.Cells.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search for anything",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: nil,
            didTapSearchIcon: { print("Search icon tapped") },
            didTapFilterIcon: { print("Filter icon tapped") },
            didStartEditing: { text in print("Started editing with: \(text)") },
            didEndEditing: { text in print("Ended editing with: \(text)") },
            onTextChanged: { text in print("Search text changed: \(text)") }
        )
    )
    
    lazy var bannerRow = CarouselRow(
        tag: Tags.Section.banner.rawValue,
        model: CarouselModel(
            items: [
                CarouselItem(image: UIImage(named: "carousel01"), text: nil, textColor: .white) { print("Tapped A") },
                CarouselItem(image: UIImage(named: "carousel02"), text: nil, textColor: .yellow) { print("Tapped B") },
                CarouselItem(image: UIImage(named: "carousel03"), text: nil, textColor: .cyan) { print("Tapped C") },
                CarouselItem(image: UIImage(named: "carousel04"), text: nil, textColor: .white) { print("Tapped D") }
            ],
            autoPlayInterval: 4,
            paginationPlacement: .inside,
            imageContentMode: .scaleAspectFill,
            transitionStyle: .fade,
            hideText: false,
            currentPageDotColor: .red,
            pageDotColor: .lightGray
        )
    )

    lazy var productCategoriesFormRow = QuickActionsFormRow(
        tag: 1,
        items: makeProductCategoryItems()
    )

    lazy var tradeServiceCategoriesFormRow = QuickActionsFormRow(
        tag: 2,
        items: makeServiceCategoryItems()
    )

    lazy var trendingProducts = GridFormRow(
        tag: Tags.Cells.trendingProducts.rawValue,
        items: makeTrendingProductItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    lazy var trendingServices = GridFormRow(
        tag: Tags.Cells.trendingServices.rawValue,
        items: makeTrendingServiceItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    // MARK: - Grid Item Builders

    private func makeProductCategoryItems() -> [QuickActionItem] {
        let count = min(state?.productCategories.count ?? 0, 5)
        return (0..<count).compactMap { index in
            guard let category = state?.productCategories[index] else { return nil }
            return QuickActionItem(
                id: "\(category.id ?? 0)",
                image: UIImage(systemName: "cart.fill"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: {
                    print("Tapped product category: \(category.name ?? category.imageUrl ?? "")")
                }
            )
        }
    }

    private func makeServiceCategoryItems() -> [QuickActionItem] {
        let count = min(state?.serviceCategories.count ?? 0, 5)
        return (0..<count).compactMap { index in
            guard let category = state?.serviceCategories[index] else { return nil }
            return QuickActionItem(
                id: "\(category.id ?? 0)",
                image: UIImage(systemName: "wrench.fill"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: {
                    print("Tapped service category: \(category.name ?? category.imageUrl ?? "")")
                }
            )
        }
    }

    private func makeTrendingProductItems() -> [GridItemModel] {
        return state?.featuredProducts.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: nil,
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: {
                    print("Tapped product: \(product.name ?? "")")
                },
                onToggleFavorite: { isFav in
                    print("Toggled favorite for product \(product.name ?? ""): \(isFav)")
                }
            )
        } ?? []
    }

    private func makeTrendingServiceItems() -> [GridItemModel] {
        return state?.featuredServices.map { service in
            GridItemModel(
                id: "\(service.id ?? 0)",
                image: nil,
                imageUrl: service.primaryImage ?? "",
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                price: service.price != nil ? "$\(String(format: "%.2f", service.price!))" : nil,
                isFavorite: false,
                onTap: {
                    print("Tapped service: \(service.name ?? "")")
                },
                onToggleFavorite: { isFav in
                    print("Toggled favorite for service \(service.name ?? ""): \(isFav)")
                }
            )
        } ?? []
    }

    // MARK: - State

    private struct State {
        var accessToken = AppStorage.accessToken ?? ""
        var featuredProducts: [ProductResponse] = []
        var featuredServices: [TradeServiceResponse] = []
        var productCategories: [CommodityCategoryResponse] = []
        var serviceCategories: [TradeServiceCategoryResponse] = []
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case categories = 0
            case serviceCategories = 1
            case banner = 3
            case trendingProducts = 6
            case trendingServices = 7
            case search = 3001
        }

        enum Cells: Int {
            case categories = 0
            case serviceCategories = 1
            case banner = 3
            case trendingProducts = 6
            case trendingServices = 7
            case search = 3001
        }
    }

    // MARK: - Data Types

    private enum HomeDataType: CustomStringConvertible {
        case featuredProducts
        case featuredServices
        case productCategories
        case serviceCategories

        var description: String {
            switch self {
            case .featuredProducts: return "Featured Products"
            case .featuredServices: return "Featured Services"
            case .productCategories: return "Product Categories"
            case .serviceCategories: return "Service Categories"
            }
        }
    }
}
