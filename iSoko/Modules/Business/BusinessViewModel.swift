//
//  BusinessViewModel.swift
//
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BusinessViewModel: FormViewModel {
    var gotoSignIn: (() -> Void)? = { }
    var gotoSignOut: (() -> Void)? = { }
    var goToBookKeeping: (() -> Void)? = { }
    
    var goToReports: (() -> Void)? = { }
    var goToTaxCalculator: (() -> Void)? = { }
    var goToCurrencyExchange: (() -> Void)? = { }
    
    var goToMyProducts: (() -> Void)? = { }
    var goToMyServices: (() -> Void)? = { }
    var goToMyOrders: (() -> Void)? = { }
 
    private var state: State
    
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - Public API
    
    // MARK: - make sections
    
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(
            FormSection(
                id: Tags.Section.header.rawValue,
                cells: [
                    headerTitleRow,
                    SpacerFormRow(tag: -0098),
                    bookKeepingRow,
                    businessHubRow
                ]
            )
        )
        
        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeImageRows()
            )
        )
        
        return sections
    }
    
    // MARK: - Lazy or Computed Rows
    private lazy var bookKeepingRow: FormRow = {
        return makeImageTitleDescriptionRow(
            tag: Tags.Cells.bookkeeping.rawValue,
            image: UIImage(systemName: "book.fill")!,
            title: "Book Keeping",
            description: "Manage your finances and bookkeeping",
            onTap: { [weak self] in
                self?.goToBookKeeping?()
            }
        )
        
    }()
    
    private lazy var businessHubRow: FormRow = {
        HubCardRow(
            tag: 1,
            config: HubCardConfig(
                icon: UIImage(systemName: "bag"),
                iconBackgroundColor: UIColor.systemBlue.withAlphaComponent(0.15),
                title: "Marketplace Hub",
                subtitle: "Manage your online store and orders",
                actions: [
                    .init(
                        id: "products",
                        icon: UIImage(systemName: "archivebox"),
                        title: "Products",
                        onTap: { [weak self] in
                            self?.goToMyProducts?()
                    }),
                    .init(
                        id: "services",
                        icon: UIImage(systemName: "wrench"),
                        title: "Services",
                        onTap: { [weak self] in
                            self?.goToMyServices?()
                        }),
                    .init(
                        id: "orders",
                        icon: UIImage(systemName: "doc.text"),
                        title: "Orders",
                        onTap: { [weak self] in
                            self?.goToMyOrders?()
                        })
                ]
            )
        )
    }()
    
    private lazy var headerTitleRow: FormRow = {
        return TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            model: TitleDescriptionModel(
            title: "Business Management",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
            )
        )
    }()
    
    // Generates a reusable ImageTitleDescriptionRow
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) -> FormRow {
        return ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .image(image: UIImage(named: "forwardArrowRightAligned") ?? .forwardArrow),
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
    }
    
    /// Easily loop and create multiple rows
    
    private func makeRowItemsArray() -> [RowItemModel] {
        var items: [RowItemModel] = []
        
        items.append(contentsOf: [
            RowItemModel(
                title: "Currency Exchange",
                description: "Convert between East african and International currencies",
                image: .bagAddIcon,
                onTap: { [weak self] in
                    self?.goToCurrencyExchange?()
            }),
            
            RowItemModel(
                title: "Analytics",
                description: "View analytics for your business",
                image: .profile,
                onTap: { [weak self] in
                    self?.goToReports?()
            }),
            RowItemModel(
                title: "Tax Calculator",
                description: "Calculate value of your Taxable goods",
                image: .tradeIcon,
                onTap: { [weak self] in
                    self?.goToTaxCalculator?()
            })
        ])
        
        return items
    }
    
    private func makeImageRows() -> [FormRow] {
        let items = makeRowItemsArray()
        
        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(
                tag: 2000 + index,
                image: item.image,
                title: item.title,
                description: item.description,
                onTap: item.onTap
            )
        }
    }
    
    // MARK: - State
    
    private struct State {
        var isLoggedIn: Bool = true
    }
    
    // MARK: - Tags
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
        
        enum Cells: Int {
            case headerImage = 0
            case headerTitle = 1
            case bookkeeping = 2
        }
    }
}
