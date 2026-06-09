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

@MainActor
final class HomeViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapMoreProduct: (() -> Void)?
    var onTapProduct: ((ProductResponseV1) -> Void)?
    var onFavoriteProductToggle: ((Bool, ProductResponseV1) -> Void)?

    var onTapMoreServices: (() -> Void)?
    var onTapService: ((TradeServiceResponse) -> Void)?
    var onFavoriteServiceToggle: ((Bool, TradeServiceResponse) -> Void)?

    var onTapMoreProductCategories: (() -> Void)?
    var onTapMoreServiceCategories: (() -> Void)?
    var onTapProductCategory: ((CommodityCategoryResponse) -> Void)?
    var onTapServiceCategory: ((TradeServiceCategoryResponse) -> Void)?

    var onTapTradeAssociation: ((AssociationResponse) -> Void)?

    var onTapTopDeal: ((TopDealItem) -> Void)?
    var onFavoriteTopDealToggle: ((Bool, TopDealItem) -> Void)?

    // MARK: - Services
    private let directusService        = DirectusTokenService()
    private let productsService        = NetworkEnvironment.shared.productsService
    private let servicesService        = NetworkEnvironment.shared.servicesService
    private let commonUtilitiesService = NetworkEnvironment.shared.commonUtilitiesService
    private let associationsService    = NetworkEnvironment.shared.associationsService
    private let countryHelper          = CountryHelper()

    // MARK: - State
    private var state = State()

    override init() {
        super.init()
        Task { @MainActor in
            sections = makeSections()
        }
    }

    // MARK: - Fetch

    override func refresh() {
        Task { await performNetworkCalls() }
    }

    override func fetchData() {
        Task { await performNetworkCalls() }
    }

    private func performNetworkCalls() async {
        showLoader()
        defer { hideLoader() }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchDataType(.featuredProducts) }
            group.addTask { await self.fetchDataType(.featuredServices) }
            group.addTask { await self.fetchDataType(.productCategories) }
            group.addTask { await self.fetchDataType(.serviceCategories) }
            group.addTask { await self.fetchDataType(.associations) }
        }

        await fetchBanners()
    }

    // MARK: - Fetch helpers

    private func fetchDataType(_ type: HomeDataType) async {
        do {
            switch type {
            case .featuredProducts:
                let result = try await productsService.getFeaturedProducts(
                    page: 1, count: 20, accessToken: state.guestToken)
                state.featuredProducts = result.data ?? []
                DispatchQueue.main.async { [weak self] in self?.updateSection(.trendingProducts) }

            case .featuredServices:
                let result = try await servicesService.getFeaturedTradeServices(
                    page: 1, count: 20, accessToken: state.guestToken)
                state.featuredServices = result
                DispatchQueue.main.async { [weak self] in self?.updateSection(.trendingServices) }

            case .productCategories:
                let result = try await commonUtilitiesService.getCommodityCategory(
                    page: 1, count: 20,
                    module: "<regulation | trade-documents | standards>",
                    accessToken: state.guestToken)
                state.productCategories = result
                DispatchQueue.main.async { [weak self] in self?.updateSection(.categories) }

            case .serviceCategories:
                let result = try await servicesService.getAllTradeServiceCategories(
                    page: 1, count: 20, accessToken: state.guestToken)
                state.serviceCategories = result
                DispatchQueue.main.async { [weak self] in self?.updateSection(.serviceCategories) }

            case .associations:
                let result = try await associationsService.getAllAssociations(
                    page: 1, count: 10, accessToken: state.oauthToken)
                state.associations = result
                await fetchAssociationProducts(for: result)
                DispatchQueue.main.async { [weak self] in self?.updateSection(.exportCards) }
            }
        } catch let NetworkError.server(apiError) {
            print("❌ API Error in \(type):", apiError.message ?? "")
        } catch {
            print("❌ Unexpected Error in \(type):", error)
        }
    }

    private func fetchAssociationProducts(for associations: [AssociationResponse]) async {
        await withTaskGroup(of: (Int, [ProductResponseV1]).self) { group in
            for association in associations {
                guard let id = association.id else { continue }
                group.addTask { [weak self] in
                    guard let self else { return (id, []) }
                    do {
                        let result = try await self.associationsService.getAssociationProducts(
                            id: id, page: 1, count: 4, accessToken: self.state.oauthToken)
                        return (id, result.data ?? [])
                    } catch {
                        print("❌ Failed to fetch products for association \(id):", error)
                        return (id, [])
                    }
                }
            }
            for await (id, products) in group {
                state.associationProducts[id] = products
            }
        }
    }

    private func fetchBanners() async {
        do {
            try await directusService.login(email: AppStorage.email, password: AppStorage.password)
            let banners = try await directusService.fetchHomeBanners()
            state.banners = banners
            DispatchQueue.main.async { [weak self] in self?.updateSection(.banner) }
        } catch {
            print("❌ Directus flow failed:", error)
        }
    }

    // MARK: - Sections
    // All sections are created upfront with empty cells and no title.
    // updateSection fills them in once data arrives — if data is empty the
    // section stays empty (no cells, no title, zero height).

    private func makeSections() -> [FormSection] {
        Tags.Section.canonicalOrder.map { tag in
            FormSection(id: tag.rawValue, title: nil, cells: [])
        }
    }

    private func updateSection(_ tag: Tags.Section) {
        guard let index = sections.firstIndex(where: { $0.id == tag.rawValue }) else { return }

        var updated = sections[index]

        switch tag {
        case .search:
            updated.title = nil
            updated.cells = [makeSearchRow()]

        case .banner:
            updated.title = nil
            updated.cells = [makeBannerRow()]

        case .categories:
            let items = makeProductCategoryItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.categories.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.onActionTapped = { [weak self] in self?.onTapMoreProductCategories?() }
            updated.cells = [QuickActionsFormRow(tag: Tags.Cells.categories.rawValue, items: items)]

        case .serviceCategories:
            let items = makeServiceCategoryItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.services.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.onActionTapped = { [weak self] in self?.onTapMoreServiceCategories?() }
            updated.cells = [QuickActionsFormRow(tag: Tags.Cells.serviceCategories.rawValue, items: items)]

        case .exportCards:
            let items = makeExportCardsItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.featured_associations.title".localized
            updated.actionTitle = nil
            updated.cells = [ExportCardsFormRow(tag: Tags.Cells.exportCards.rawValue, items: items)]

        case .trendingProducts:
            let items = makeTrendingProductItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.trending_products.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.onActionTapped = { [weak self] in self?.onTapMoreProduct?() }
            updated.cells = [
                FeaturedDealsGridFormRow(tag: Tags.Cells.trendingProducts.rawValue, items: items, columns: 2),
                SpacerFormRow(tag: 000, height: 40)
            ]

        case .trendingServices:
            let items = makeTrendingServiceItemsForFeaturedGrid()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.trending_services.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.onActionTapped = { [weak self] in self?.onTapMoreServices?() }
            updated.cells = [FeaturedDealsGridFormRow(tag: Tags.Cells.trendingServices.rawValue, items: items, columns: 2)]

        case .topDeals:
            let items = makeTopDealItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.top_deals.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.cells = [TopDealsFormRow(tag: Tags.Cells.topDeals.rawValue, items: items)]

        case .opportunities:
            let items = makeOpportunityItems()
            guard !items.isEmpty else {
                updated.title = nil
                updated.cells = []
                sections[index] = updated
                reloadSection(index)
                return
            }
            updated.title = "home.opportunities.title".localized
            updated.actionTitle = "common.action.see_all".localized
            updated.onActionTapped = { print("See All") }
            updated.cells = [OpportunityFormRow(tag: Tags.Cells.opportunities.rawValue, items: items)]
        }

        sections[index] = updated
        reloadSection(index)
    }

    // MARK: - Item builders

    private func makeSearchRow() -> FormRow {
        SearchFormRow(
            tag: Tags.Cells.search.rawValue,
            model: SearchFormModel(
                placeholder: "common.label.search".localized,
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
    }

    private func makeBannerRow() -> FormRow {
        CarouselRow(
            tag: Tags.Section.banner.rawValue,
            model: CarouselModel(
                items: makeCarouselItems(),
                autoPlayInterval: 4,
                paginationPlacement: .inside,
                imageContentMode: .scaleAspectFill,
                transitionStyle: .fade,
                hideText: false,
                currentPageDotColor: .red,
                pageDotColor: .lightGray
            )
        )
    }

    private func makeCarouselItems() -> [CarouselItem] {
        let banners = transformBannersToCarouselItems(banners: state.banners)
        guard !banners.isEmpty else {
            return [
                CarouselItem(image: UIImage(named: "carousel01"), imageURL: nil, text: nil, textColor: .white) { print("Tapped A") },
                CarouselItem(image: UIImage(named: "carousel02"), imageURL: nil, text: nil, textColor: .yellow) { print("Tapped B") },
                CarouselItem(image: UIImage(named: "carousel03"), imageURL: nil, text: nil, textColor: .cyan) { print("Tapped C") },
                CarouselItem(image: UIImage(named: "carousel04"), imageURL: nil, text: nil, textColor: .white) { print("Tapped D") }
            ]
        }
        return banners
    }

    private func transformBannersToCarouselItems(banners: [DirectusHomeBannerItem]) -> [CarouselItem] {
        banners.compactMap { banner in
            let imageURL = banner.imageLink?.urlString(baseURL: "https://directus.dev.isoko.africa/")
            return CarouselItem(imageURL: imageURL, text: nil, textColor: .white) {
                print("Tapped \(banner.title ?? "Unknown")")
            }
        }
    }

    private func makeProductCategoryItems() -> [QuickActionItem] {
        state.productCategories.prefix(5).compactMap { category in
            QuickActionItem(
                id: "\(category.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: category.imageUrl?.isEmpty == false ? category.imageUrl : category.url,
                imageShape: .circle,
                title: category.name ?? "",
                onTap: { [weak self] in self?.onTapProductCategory?(category) }
            )
        }
    }

    private func makeServiceCategoryItems() -> [QuickActionItem] {
        state.serviceCategories.prefix(5).compactMap { category in
            QuickActionItem(
                id: "\(category.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: { [weak self] in self?.onTapServiceCategory?(category) }
            )
        }
    }

    private func makeTrendingProductItems() -> [FeaturedDealItem] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        return state.featuredProducts.map { product in
            FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: product.primaryImageURL ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.description ?? "",
                priceText: product.price != nil
                    ? "\(currency) \(String(format: "%.2f", product.price!))"
                    : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in self?.onTapProduct?(product) },
                onFavoriteToggle: { [weak self] isFav in self?.onFavoriteProductToggle?(isFav, product) }
            )
        }
    }

    private func makeTrendingServiceItemsForFeaturedGrid() -> [FeaturedDealItem] {
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegion ?? "")
        return state.featuredServices.map { service in
            FeaturedDealItem(
                id: "\(service.id ?? 0)",
                imageUrl: service.primaryImage ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                priceText: service.price != nil
                    ? "\(currency) \(String(format: "%.2f", service.price!))"
                    : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in self?.onTapService?(service) },
                onFavoriteToggle: { [weak self] isFav in self?.onFavoriteServiceToggle?(isFav, service) }
            )
        }
    }

    private func makeExportCardsItems() -> [ExportCardItem] {
        state.associations.prefix(10).map { association in
            let id = association.id ?? 0
            let products = state.associationProducts[id] ?? []
            let imageUrls = products.compactMap { $0.primaryImageURL }.prefix(4).map { $0 }
            let images: [UIImage?] = imageUrls.map { _ in UIImage(named: "blank_rectangle") }
            let managerName: String = {
                guard let m = association.manager else { return "Unknown" }
                return "\(m.firstName ?? "") \(m.lastName ?? "")"
            }()
            return ExportCardItem(
                id: "\(id)",
                title: association.name ?? "Unnamed Association",
                subtitle: managerName,
                icon: nil,
                imageUrls: imageUrls,
                images: images,
                onTap: { [weak self] in self?.onTapTradeAssociation?(association) }
            )
        }
    }

    private func makeTopDealItems() -> [TopDealItem] {
        let dummyTitles = [
            "Kitenge Fashion", "Hand-Carved Stool",
            "Luxury Coffee Beans", "Organic Honey", "Handwoven Basket"
        ]
        return (0..<5).map { index in
            TopDealItem(
                id: "\(index)",
                imageUrl: nil,
                image: UIImage(named: "blank_rectangle"),
                badgeText: index == 0 ? "Popular" : nil,
                title: dummyTitles[index],
                subtitle: "by Zawadi Designs",
                priceText: "KES \(2_500 + (index * 300)) / Piece",
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self else { return }
                    self.onTapTopDeal?(self.makeTopDealItems()[index])
                },
                onFavoriteToggle: { [weak self] isFav in
                    guard let self else { return }
                    self.onFavoriteTopDealToggle?(isFav, self.makeTopDealItems()[index])
                }
            )
        }
    }

    private func makeOpportunityItems() -> [OpportunityItem] {
        [
            OpportunityItem(
                id: "op1", image: UIImage(named: "op1"),
                title: "Fursa ya mafunzo na mitaji kutoka Stanbic Bank",
                subtitle: "Partner Association", location: "Region, Kenya",
                category: "Finance", onTap: { print("Op 1 tapped") }
            ),
            OpportunityItem(
                id: "op2", image: UIImage(named: "op2"),
                title: "Fursa ya mafunzo na mitaji kutoka Stanbic Bank",
                subtitle: "Partner Association", location: "Region, Kenya",
                category: "Finance", onTap: { print("Op 2 tapped") }
            )
        ]
    }
}

// MARK: - State + Tags

extension HomeViewModel {

    private struct State {
        var oauthToken:          String                        = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken:          String                        = AppStorage.guestToken?.accessToken ?? ""
        var hasLoggedIn:         Bool                          = AppStorage.hasLoggedIn ?? false
        var featuredProducts:    [ProductResponseV1]           = []
        var featuredServices:    [TradeServiceResponse]        = []
        var productCategories:   [CommodityCategoryResponse]   = []
        var serviceCategories:   [TradeServiceCategoryResponse] = []
        var associations:        [AssociationResponse]         = []
        var associationProducts: [Int: [ProductResponseV1]]    = [:]
        var banners:             [DirectusHomeBannerItem]      = []
    }

    enum Tags {
        enum Section: Int {
            case search            = 3001
            case banner            = 3
            case categories        = 0
            case serviceCategories = 1
            case exportCards       = 8
            case trendingProducts  = 6
            case trendingServices  = 7
            case topDeals          = 4
            case opportunities     = 9

            static let canonicalOrder: [Section] = [
                .search, .banner, .categories, .serviceCategories,
                .exportCards, .trendingProducts, .trendingServices,
                .topDeals, .opportunities
            ]
        }

        enum Cells: Int {
            case search            = 3001
            case banner            = 3
            case categories        = 0
            case serviceCategories = 1
            case exportCards       = 8
            case trendingProducts  = 6
            case trendingServices  = 7
            case topDeals          = 4
            case opportunities     = 9
        }
    }

    private enum HomeDataType: CustomStringConvertible {
        case featuredProducts, featuredServices
        case productCategories, serviceCategories
        case associations

        var description: String {
            switch self {
            case .featuredProducts:  return "Featured Products"
            case .featuredServices:  return "Featured Services"
            case .productCategories: return "Product Categories"
            case .serviceCategories: return "Service Categories"
            case .associations:      return "Associations"
            }
        }
    }
}
