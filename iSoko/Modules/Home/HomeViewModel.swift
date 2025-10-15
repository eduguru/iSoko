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

            // TODO: Update UI here if needed (e.g. reloadSections())
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
            FormSection(id: 001, cells: [searchRow]),
            makeCategoriesQuickActionsSection(),
            makeServicesQuickActionsSection(),
            makeBannerSection(),
            makeTrndingProductsSection(),
            makeTrndingServicesSection()
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

    private func makeTrndingProductsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.trendingProducts.rawValue,
            title: "Trending Products",
            cells: [trendingProducts]
        )
    }

    private func makeTrndingServicesSection() -> FormSection {
        return FormSection(
            id: Tags.Section.trendingServices.rawValue,
            title: "Trending Services",
            cells: [trendingServices]
        )
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
        items: populateTrendingProductsItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    lazy var trendingServices = GridFormRow(
        tag: Tags.Cells.trendingServices.rawValue,
        items: populateTrendingServicesItems(),
        numberOfColumns: 2,
        useCollectionView: false
    )

    // MARK: - Grid Item Populators
    func makeProductCategoryItems() -> [QuickActionItem] {
        let count = 5// state?.productCategories.count ?? 0
        return (0..<count).map { index in
            // let category = state?.productCategories[index]
            
            return QuickActionItem(  // <-- Add 'return' here
                id: "\(0)",
                image: UIImage(systemName: "cart.fill"),  // Replace with your actual image or URL if available
                imageUrl: nil,
                imageShape: .circle,
                title: "title",
                onTap: {
                    print("Tapped product category: \("unknown")")
                }
            )
        }
    }

    func makeServiceCategoryItems() -> [QuickActionItem] {
        let count = 5 // state?.serviceCategories.count ?? 0
        return (0..<count).map { index in
            // let category = state?.serviceCategories[index]
            
            return QuickActionItem(  // <-- Add 'return' here
                id: "\(0)",
                image: UIImage(systemName: "wrench.fill"), // Replace with your actual image or URL if available
                imageUrl: nil,
                imageShape: .circle,
                title: "title 0",
                onTap: {
                    print("Tapped service category: \("unknown")")
                }
            )
        }
    }

    private func populateTrendingProductsItems() -> [GridItemModel] {
        var items: [GridItemModel] = []
        for _ in 0..<10 {
            items.append(
                GridItemModel(
                    id: "1",
                    image: UIImage(named: "carousel04")!,
                    title: "Product One",
                    subtitle: "Best Seller",
                    price: "$9.99",
                    isFavorite: false,
                    onTap: { print("Tapped product 1") },
                    onToggleFavorite: { isFav in print("Favorite toggled to: \(isFav)") }
                )
            )
        }
        return items
    }

    private func populateTrendingServicesItems() -> [GridItemModel] {
        var items: [GridItemModel] = []
        for _ in 0..<10 {
            items.append(
                GridItemModel(
                    id: "1",
                    image: UIImage(named: "carousel04")!,
                    title: "Service One",
                    subtitle: "Top Rated",
                    price: "$19.99",
                    isFavorite: false,
                    onTap: { print("Tapped service 1") },
                    onToggleFavorite: { isFav in print("Favorite toggled to: \(isFav)") }
                )
            )
        }
        return items
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

    // MARK: - Home Data Type Enum

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


extension Double { // $0.price?.toCurrencyString() ?? "$0.00"
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
