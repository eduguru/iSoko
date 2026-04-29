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
    
    var onTapTopDeal: ((TopDealItem) -> Void)?
    var onFavoriteTopDealToggle: ((Bool, TopDealItem) -> Void)?
    
    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    private let servicesService = NetworkEnvironment.shared.servicesService
    private let commonUtilitiesService = NetworkEnvironment.shared.commonUtilitiesService
    private let associationsService = NetworkEnvironment.shared.associationsService
    
    private let countryHelper = CountryHelper()
    
    // MARK: - State
    private var state: State?
    
    override init() {
        self.state = State()
        super.init()
        
        Task { @MainActor in
            self.sections = self.makeSections()
        }
    }
    
    // MARK: - Fetch
    override func fetchData() {
        showLoader()
        
        // MARK: - Fetch
        Task {
            async let _ = fetchDataType(.featuredProducts)
            async let _ = fetchDataType(.featuredServices)
            async let _ = fetchDataType(.productCategories)
            async let _ = fetchDataType(.serviceCategories)
            async let _ = fetchDataType(.associations)
            
            _ = await ((), (), (), (), ())
            
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
                //                let response = try await productsService.getFeaturedProducts(
                //                    page: 1, count: 20, accessToken: state?.guestToken ?? "")
                //                self.state?.featuredProducts = response
                //                print("✅ Fetched Featured Products")
                //
                //                DispatchQueue.main.async { [weak self] in
                //                    self?.updateTrendingProductsSection()
                //                }
                
                let result = try await productsService.getFeaturedProducts(
                    page: 1,
                    count: 20,
                    accessToken: state?.guestToken ?? ""
                )
                
                self.state?.featuredProducts = result.data
                
                print("✅ Fetched Featured Products")
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTrendingProductsSection()
                }
                
            case .featuredServices:
                let response = try await servicesService.getFeaturedTradeServices(
                    page: 1, count: 20, accessToken: state?.guestToken ?? "")
                self.state?.featuredServices = response
                print("✅ Fetched Featured Services")
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateTrendingServicesSection()
                }
                
            case .productCategories:
                let response = try await commonUtilitiesService.getCommodityCategory(
                    page: 1, count: 20, module: "<regulation | trade-documents | standards>",
                    accessToken: state?.guestToken ?? "")
                self.state?.productCategories = response
                print("✅ Fetched Product Categories")
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateProductCategoriesSection()
                }
                
            case .serviceCategories:
                let response = try await servicesService.getAllTradeServiceCategories(
                    page: 1, count: 20, accessToken: state?.guestToken ?? "")
                self.state?.serviceCategories = response
                print("✅ Fetched Service Categories")
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateServiceCategoriesSection()
                }
                
            case .associations:
                let response = try await associationsService.getAllAssociations(
                    page: 1,
                    count: 10,
                    accessToken: state?.oauthToken ?? ""
                )
                
                self.state?.associations = response
                
                print("✅ Fetched Associations")
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateExportCardsSection()
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
            makeBannerSection(),
            makeCategoriesQuickActionsSection(),
            // makeServicesQuickActionsSection(),
            // makeTopDealsSection(),
            makeExportCardsSection(),
            // makeOpportunitySection(),
            makeTrendingProductsSection(),
            // makeTrendingServicesSection()
        ]
    }
    
    private func makeCategoriesQuickActionsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.categories.rawValue,
            title: "Product Categories",
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
            title: "Service Categories",
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
    
    private func makeTopDealsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.topDeals.rawValue,
            title: "Top Deals",
            actionTitle: "See All",
            onActionTapped: { [weak self] in
                // Implement later
            },
            cells: [topDealsRow]
        )
    }
    
    private func makeExportCardsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.exportCards.rawValue,
            title: "Featured Associations",
            actionTitle: "See All",
            onActionTapped: {
                print("See All Export Councils")
            },
            cells: [exportCardsRow]
        )
    }
    
    private func updateTopDealsSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.topDeals.rawValue }) else {
            return
        }
        
        let updatedRow = TopDealsFormRow(
            tag: Tags.Cells.topDeals.rawValue,
            items: makeTopDealItems()
        )
        
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
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
        guard let sectionIndex = sections.firstIndex(
            where: { $0.id == Tags.Section.trendingProducts.rawValue }
        ) else { return }
        
        let updatedRow = FeaturedDealsGridFormRow(
            tag: Tags.Cells.trendingProducts.rawValue,
            items: makeTrendingProductItems(),
            columns: 2
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
        
        let updatedRow = FeaturedDealsGridFormRow(
            tag: Tags.Cells.trendingServices.rawValue,
            items: makeTrendingServiceItemsForFeaturedGrid(),
            columns: 2
        )
        
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }
    
    private func updateExportCardsSection() {
        guard let sectionIndex = sections.firstIndex(where: {
            $0.id == Tags.Section.exportCards.rawValue
        }) else { return }
        
        let updatedRow = ExportCardsFormRow(
            tag: Tags.Cells.exportCards.rawValue,
            items: makeExportCardsItems()
        )
        
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        
        reloadSection(sectionIndex)
    }
    
    // MARK: - Form Rows
    lazy var topDealsRow = TopDealsFormRow(
        tag: Tags.Cells.topDeals.rawValue,
        items: makeTopDealItems()
    )
    
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
    
    lazy var trendingProducts = FeaturedDealsGridFormRow(
        tag: Tags.Cells.trendingProducts.rawValue,
        items: makeTrendingProductItems(),
        columns: 2
    )
    
    lazy var trendingServices = FeaturedDealsGridFormRow(
        tag: Tags.Cells.trendingServices.rawValue,
        items: makeTrendingServiceItemsForFeaturedGrid(),
        columns: 2
    )
    
    // MARK: - Item Builders
    
    private func makeTrendingServiceItemsForFeaturedGrid() -> [FeaturedDealItem] {
        return state?.featuredServices.map { service in
            
            let currency = countryHelper.currencyString(for: AppStorage.selectedRegion ?? "") ?? "$"
            let priceText = service.price != nil ? "\(currency) \(String(format: "%.2f", service.price!))" : "Price on request"
            
            return FeaturedDealItem(
                id: "\(service.id ?? 0)",
                imageUrl: service.primaryImage ?? "",
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: service.name ?? "Unnamed Service",
                subtitle: service.traderName ?? "",
                priceText: priceText,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapService?(service)
                },
                onFavoriteToggle: { [weak self] isFav in
                    self?.onFavoriteServiceToggle?(isFav, service)
                }
            )
        } ?? []
    }

    private func makeProductCategoryItems() -> [QuickActionItem] {
        let count = min(state?.productCategories.count ?? 0, 5)

        return (0..<count).compactMap { index in
            guard let category = state?.productCategories[index] else { return nil }
            
            print("Category:", category.name ?? "")
            print("🖼 Image URL:", category.imageUrl ?? "nil")

            return QuickActionItem(
                id: "\(category.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: category.imageUrl?.isEmpty == false ? category.imageUrl : category.url,
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
                image: UIImage(named: "blank_rectangle"),
                imageUrl: category.imageUrl ?? "",
                imageShape: .circle,
                title: category.name ?? "",
                onTap: { [weak self] in
                    self?.onTapServiceCategory?(category)
                }
            )
        }
    }
    
    private func makeTrendingProductItems() -> [FeaturedDealItem] {
        
        return state?.featuredProducts.map { product in
            
            let imageUrl = product.primaryImageURL ?? ""
            let currency = countryHelper.currencyString(for: AppStorage.selectedRegion ?? "") ?? "$"
            
            return FeaturedDealItem(
                id: "\(product.id ?? 0)",
                imageUrl: imageUrl,
                image: UIImage(named: "blank_rectangle"),
                badgeText: nil,
                title: product.name ?? "Unnamed Product",
                subtitle: product.description ?? "",
                priceText: product.price != nil
                ? "\(currency) \(String(format: "%.2f", product.price!))"
                : "Price on request",
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapProduct?(product)
                },
                onFavoriteToggle: { [weak self] isFav in
                    self?.onFavoriteProductToggle?(isFav, product)
                }
            )
        } ?? []
    }
    
    private func makeTrendingServiceItems() -> [GridItemModel] {
        return state?.featuredServices.map { service in
            GridItemModel(
                id: "\(service.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
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
    
    private func makeTopDealItems() -> [TopDealItem] {
        
        let dummyTitles = [
            "Kitenge Fashion",
            "Hand-Carved Stool",
            "Luxury Coffee Beans",
            "Organic Honey",
            "Handwoven Basket"
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
                    guard let self = self else { return }
                    self.onTapTopDeal?(self.makeTopDealItems()[index])
                },
                onFavoriteToggle: { [weak self] isFav in
                    guard let self = self else { return }
                    let item = self.makeTopDealItems()[index]
                    self.onFavoriteTopDealToggle?(isFav, item)
                }
            )
        }
    }
    
    private func makeExportCardsItems() -> [ExportCardItem] {
        
        guard let associations = state?.associations else { return [] }
        
        return associations.prefix(10).map { association in
            
            let images: [UIImage?] = association.documents?
                .compactMap { doc in
                    guard let urlString = doc.document else { return nil }
                    return UIImage(named: "blank_rectangle") // placeholder (replace with async loading if needed)
                } ?? []
            
            let managerName: String = {
                guard let manager = association.manager else { return "Unknown" }
                return "\(manager.firstName ?? "") \(manager.lastName ?? "")"
            }()
            
            return ExportCardItem(
                id: "\(association.id ?? 0)",
                title: association.name ?? "Unnamed Association",
                subtitle: managerName,
                icon: nil,
                images: Array(images.prefix(4)),
                onTap: {
                    print("Tapped association: \(association.name ?? "")")
                }
            )
        }
    }
    
    lazy var exportCardsRow = ExportCardsFormRow(
        tag: 99,
        items: makeExportCardsItems()
    )
    
    private func makeOpportunityItems() -> [OpportunityItem] {
        return [
            OpportunityItem(
                id: "op1",
                image: UIImage(named: "op1"),
                title: "Fursa ya mafunzo na mitaji kutoka Stanbic Bank",
                subtitle: "Partner Association",
                location: "Region, Kenya",
                category: "Finance",
                onTap: { print("Op 1 tapped") }
            ),
            OpportunityItem(
                id: "op2",
                image: UIImage(named: "op2"),
                title: "Fursa ya mafunzo na mitaji kutoka Stanbic Bank",
                subtitle: "Partner Association",
                location: "Region, Kenya",
                category: "Finance",
                onTap: { print("Op 2 tapped") }
            )
        ]
    }
    
    lazy var opportunityRow = OpportunityFormRow(tag: 99, items: makeOpportunityItems())
    
    private func makeOpportunitySection() -> FormSection {
        FormSection(
            id: Tags.Section.opportunities.rawValue,
            title: "Opportunities",
            actionTitle: "See All",
            onActionTapped: { print("See All") },
            cells: [opportunityRow]
        )
    }
    
    
    // MARK: - State
    private struct State {
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        //var featuredProducts: [ProductResponse] = []
        var featuredProducts: [ProductResponseV1] = []
        
        var featuredServices: [TradeServiceResponse] = []
        var productCategories: [CommodityCategoryResponse] = []
        var serviceCategories: [TradeServiceCategoryResponse] = []
        
        var associations: [AssociationResponse] = []
    }
    
    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case categories = 0
            case serviceCategories = 1
            case banner = 3
            case topDeals = 4
            case exportCards = 8
            case trendingProducts = 6
            case trendingServices = 7
            case opportunities = 9
            case search = 3001
        }
        
        enum Cells: Int {
            case categories = 0
            case serviceCategories = 1
            case banner = 3
            case topDeals = 4
            case exportCards = 8
            case trendingProducts = 6
            case trendingServices = 7
            case opportunities = 9
            case search = 3001
        }
    }
    
    // MARK: - Data Types
    private enum HomeDataType: CustomStringConvertible {
        case featuredProducts
        case featuredServices
        case productCategories
        case serviceCategories
        case associations
        
        
        var description: String {
            switch self {
            case .featuredProducts: return "Featured Products"
            case .featuredServices: return "Featured Services"
            case .productCategories: return "Product Categories"
            case .serviceCategories: return "Service Categories"
            case .associations:
                return "Associations"
            }
        }
    }
}
