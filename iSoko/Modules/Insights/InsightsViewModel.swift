//
//  InsightsViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class InsightsViewModel: FormViewModel {
    
    private var state: State?
    
    // MARK: - Callbacks (Now Optional)
    var handleMarketPrices: (() -> Void)?
    var handleTradeDocuments: (() -> Void)?
    var handleTradeProcedures: (() -> Void)?
    var handleRegulatoryAgencies: (() -> Void)?
    var handleStandards: (() -> Void)?
    var handleTaxInformation: (() -> Void)?
    var handleEvents: (() -> Void)?
    var handleForum: (() -> Void)?
    
    // MARK: - Initializer
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
        
        updateTrendingServicesSection()
    }
    
    // MARK: - Public API
    
    // MARK: - make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(FormSection(id: Tags.Section.header.rawValue, cells: [headerTitleRow]))
        sections.append(FormSection(id: Tags.Section.body.rawValue, cells: [trendingServices]))
        
        return sections
    }
    
    // MARK: - Lazy or Computed Rows
    private lazy var headerTitleRow: FormRow = {
        return TitleDescriptionFormRow(
            tag: Tags.Cells.headerTitle.rawValue,
            title: "Trade Information",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    }()
    
    lazy var trendingServices = SimpleImageTitleGridFormRow(
        tag: Tags.Cells.trendingServices.rawValue,
        items: makeTrendingServiceItems(),
        numberOfColumns: 2
    )
    
    // MARK: - Dynamic Items Creation
    private func makeTrendingServiceItems() -> [SimpleImageTitleGridModel] {
        // List of service items with their titles and callbacks
        let serviceItems: [ServiceItem] = [
            ServiceItem(id: "marketPrices", title: "Market Prices", onTap: handleMarketPrices),
            ServiceItem(id: "tradeDocuments", title: "Trade Documents", onTap: handleTradeDocuments),
            ServiceItem(id: "tradeProcedures", title: "Trade Procedures", onTap: handleTradeProcedures),
            ServiceItem(id: "regulatoryAgencies", title: "Regulatory Agencies", onTap: handleRegulatoryAgencies),
            ServiceItem(id: "standards", title: "Standards", onTap: handleStandards),
            ServiceItem(id: "taxInformation", title: "Tax Information", onTap: handleTaxInformation),
            ServiceItem(id: "events", title: "Events", onTap: handleEvents),
            ServiceItem(id: "forum", title: "Forum", onTap: handleForum)
        ]
        
        // Map serviceItems to SimpleImageTitleGridModel
        let items: [SimpleImageTitleGridModel] = serviceItems.map { item in
            SimpleImageTitleGridModel(
                id: item.id,
                image: .addDocument,
                title: item.title,
                onTap: item.onTap
            )
        }
        
        // Update the state
        state?.featuredServices = items
        return items
    }
    
    // MARK: - Update Section
    private func updateTrendingServicesSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.body.rawValue }) else {
            return
        }
        
        let updatedRow = SimpleImageTitleGridFormRow(
            tag: Tags.Cells.trendingServices.rawValue,
            items: makeTrendingServiceItems(),
            numberOfColumns: 2
        )
        
        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }
    
    // MARK: - State
    private struct State {
        var isLoggedIn: Bool = true
        var featuredServices: [SimpleImageTitleGridModel] = []
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
            case trendingServices = 2
        }
    }
}

// MARK: - ServiceItem Model (For Dynamic Grid Item Creation)
struct ServiceItem {
    let id: String
    let title: String
    let onTap: (() -> Void)?
}
