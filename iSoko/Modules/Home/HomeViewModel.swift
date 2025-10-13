//
//  HomeViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class HomeViewModel: FormViewModel {
    private var state: State?

    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }

    // MARK: - make sections

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
            cells: [categoriesFormRow]
        )
    }
    
    private func makeServicesQuickActionsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.serviceCategories.rawValue,
            title: "Explore Service Categories",
            cells: [categoriesFormRow]
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
            id: Tags.Section.trendingProducts.rawValue,
            title: "Trending Services",
            cells: [trendingServices]
        )
    }
    
    //MARK: - rows -

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
            transitionStyle: .fade,          // <-- Fade transition
            hideText: false,                 // <-- Set to true to hide all labels
            currentPageDotColor: .red,       // <-- Customize active dot color
            pageDotColor: .lightGray         // <-- Customize inactive dots
        )
    )
    
    lazy var categoriesFormRow =  QuickActionsFormRow(tag: 1, items: [
        QuickActionItem(
            id: "1",
            image: UIImage(systemName: "paperplane.fill") ?? UIImage(),
            imageShape: .circle,
            title: "Send Money",
            onTap: { print("Send Money tapped") }
        ),
        QuickActionItem(
            id: "2",
            image: UIImage(systemName: "tray.and.arrow.down.fill") ?? UIImage(),
            imageShape: .rounded(12),
            title: "Request",
            titleColor: .secondaryLabel,
            onTap: { print("Request tapped") }
        ),
        QuickActionItem(
            id: "3",
            image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
            imageShape: .square,
            title: "Top Up",
            onTap: { print("Top Up tapped") }
        ),
        QuickActionItem(
            id: "4",
            image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
            imageShape: .square,
            title: "Top Up",
            onTap: { print("Top Up tapped") }
        ),
        QuickActionItem(
            id: "5",
            image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
            imageShape: .square,
            title: "Top Up",
            onTap: { print("Top Up tapped") }
        ),
        QuickActionItem(
            id: "6",
            image: UIImage(systemName: "plus.circle.fill") ?? UIImage(),
            imageShape: .square,
            title: "Top Up",
            onTap: { print("Top Up tapped") }
        )
    ])
    
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
    
    // MARK: - funcs
    
    private func populateTrendingProductsItems() -> [GridItemModel] {
        var items: [GridItemModel] = []
        for i in 0..<10 {
            items.append(
                GridItemModel(
                    id: "1",
                    image: UIImage(named: "carousel04")!,
                    title: "Product One",
                    subtitle: "Best Seller",
                    price: "$9.99",
                    isFavorite: false,
                    onTap: {
                        print("Tapped product 1")
                    },
                    onToggleFavorite: { isFav in
                        print("Favorite toggled to: \(isFav)")
                    }
                )
            )
        }
        
        return items
    }
    
    private func populateTrendingServicesItems() -> [GridItemModel] {
        var items: [GridItemModel] = []
        for i in 0..<10 {
            items.append(
                GridItemModel(
                    id: "1",
                    image: UIImage(named: "carousel04")!,
                    title: "Product One",
                    subtitle: "Best Seller",
                    price: "$9.99",
                    isFavorite: false,
                    onTap: {
                        print("Tapped product 1")
                    },
                    onToggleFavorite: { isFav in
                        print("Favorite toggled to: \(isFav)")
                    }
                )
            )
        }
        
        return items
    }
    
    // MARK: - State

    private struct State {
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
}
