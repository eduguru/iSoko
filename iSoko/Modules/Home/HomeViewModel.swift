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

    // MARK: - Callbacks
    var onTapMoreProduct: (() -> Void)?
    var onTapProduct: ((ProductResponse) -> Void)?
    var onFavoriteProductToggle: ((Bool, ProductResponse) -> Void)?

    var onTapMoreServices: (() -> Void)?
    var onTapService: ((TradeServiceResponse) -> Void)?
    var onFavoriteServiceToggle: ((Bool, TradeServiceResponse) -> Void)?

    var onTapMoreProductCategories: (() -> Void)?
    var onTapMoreServiceCategories: (() -> Void)?
    var onTapProductCategory: ((CommodityCategoryResponse) -> Void)?
    var onTapServiceCategory: ((TradeServiceCategoryResponse) -> Void)?

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
        showLoader()

        Task {
            async let _ = fetchDataType(.featuredProducts)
            async let _ = fetchDataType(.featuredServices)
            async let _ = fetchDataType(.productCategories)
            async let _ = fetchDataType(.serviceCategories)

            _ = await ((), (), (), ())

            DispatchQueue.main.async { [weak self] in
                self?.hideLoader()
            }
        }
    }

    // MARK: - Fetch Helper
    @discardableResult
    private func fetchDataType(_ type: HomeDataType) async -> Bool {
        do {
            switch type {
            case .featuredProducts:
                let response = try await productsService.getFeaturedProducts(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.featuredProducts = response
                print("✅ Fetched Featured Products")

                DispatchQueue.main.async { [weak self] in
                    self?.updateTrendingProductsSection()
                }

            case .featuredServices:
                let response = try await servicesService.getFeaturedTradeServices(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.featuredServices = response
                print("✅ Fetched Featured Services")

                DispatchQueue.main.async { [weak self] in
                    self?.updateTrendingServicesSection()
                }

            case .productCategories:
                let response = try await commonUtilitiesService.getCommodityCategory(
                    page: 1, count: 20, module: "<regulation | trade-documents | standards>",
                    accessToken: state?.accessToken ?? "")
                self.state?.productCategories = response
                print("✅ Fetched Product Categories")

                DispatchQueue.main.async { [weak self] in
                    self?.updateProductCategoriesSection()
                }

            case .serviceCategories:
                let response = try await servicesService.getAllTradeServiceCategories(
                    page: 1, count: 20, accessToken: state?.accessToken ?? "")
                self.state?.serviceCategories = response
                print("✅ Fetched Service Categories")

                DispatchQueue.main.async { [weak self] in
                    self?.updateServiceCategoriesSection()
                }
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
            actionTitle: "See All",
            onActionTapped: { [weak self] in
                self?.onTapMoreProductCategories?()
            },
            cells: [productCategoriesFormRow]
        )
    }

    private func makeServicesQuickActionsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.serviceCategories.rawValue,
            title: "Explore Service Categories",
            actionTitle: "See All",
            onActionTapped: { [weak self] in
                self?.onTapMoreServiceCategories?()
            },
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
            actionTitle: "See All",
            onActionTapped: { [weak self] in
                self?.onTapMoreProduct?()
            },
            cells: [trendingProducts]
        )
    }

    private func makeTrendingServicesSection() -> FormSection {
        return FormSection(
            id: Tags.Section.trendingServices.rawValue,
            title: "Trending Services",
            actionTitle: "See All",
            onActionTapped: { [weak self] in
                self?.onTapMoreServices?()
            },
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
                image: UIImage(named: "logo"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: { [weak self] in
                    self?.onTapProductCategory?(category)
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
                image: UIImage(named: "logo"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: { [weak self] in
                    self?.onTapServiceCategory?(category)
                }
            )
        }
    }

    private func makeTrendingProductItems() -> [GridItemModel] {
        return state?.featuredProducts.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapProduct?(product)
                },
                onToggleFavorite: { [weak self] isFav in
                    self?.onFavoriteProductToggle?(isFav, product)
                }
            )
        } ?? []
    }

    private func makeTrendingServiceItems() -> [GridItemModel] {
        return state?.featuredServices.map { service in
            GridItemModel(
                id: "\(service.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: service.primaryImage ?? "",
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                price: service.price != nil ? "$\(String(format: "%.2f", service.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapService?(service)
                },
                onToggleFavorite: { [weak self] isFav in
                    self?.onFavoriteServiceToggle?(isFav, service)
                }
            )
        } ?? []
    }

    // MARK: - State
    private struct State {
        var accessToken = AppStorage.authToken?.accessToken ?? ""
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
