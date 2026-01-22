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
    var goToMyProducts: (() -> Void)? = { }
    var goToMyServices: (() -> Void)? = { }
    var goToMyOrders: (() -> Void)? = { }
    var goToReports: (() -> Void)? = { }
    var goToTaxCalculator: (() -> Void)? = { }
    var goToCurrencyExchange: (() -> Void)? = { }
 
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
    
    private lazy var headerTitleRow: FormRow = {
        return TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            title: "Business Management",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    }()
    
    /// Generates a reusable ImageTitleDescriptionRow
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
            RowItemModel(title: "My Products", description: "", image: .legalIcon, onTap: { [weak self] in
                self?.goToMyProducts?()
            }),
            RowItemModel(title: "My Services", description: "", image: .settingsGearIcon, onTap: { [weak self] in
                self?.goToMyServices?()
            }),
            RowItemModel(title: "My Orders", description: "", image: .questionCircleIcon, onTap: { [weak self] in
                self?.goToMyOrders?()
            }),
            
            RowItemModel(title: "Reports", description: "", image: .profile, onTap: { [weak self] in
                self?.goToReports?()
            }),
            RowItemModel(title: "Book Keeping", description: "", image: .orgIcon, onTap: { [weak self] in
                self?.goToBookKeeping?()
            }),
            RowItemModel(title: "Tax Calculator", description: "", image: .tradeIcon, onTap: { [weak self] in
                self?.goToTaxCalculator?()
            }),
            RowItemModel(title: "Currency Exchange", description: "", image: .bagAddIcon, onTap: { [weak self] in
                self?.goToCurrencyExchange?()
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
        }
    }
}
