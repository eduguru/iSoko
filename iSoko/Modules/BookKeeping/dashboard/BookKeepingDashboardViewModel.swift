//
//  BookKeepingDashboardViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingDashboardViewModel: FormViewModel {
   var goToDetails: (() -> Void)? = { }
    
    private var state = State()

    override init() {
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections -
    private func makeSections() -> [FormSection] {
        [
            makeFilterSection(),
            makeFinancialSummarySection(),
            makeQuickActionsSection(),
            makeBusinessMetricsSection(),
            makeRecentActivitiesSection()
        ]
    }

    private func makeFilterSection() -> FormSection {
        FormSection(
            id: Tags.Section.filter.rawValue,
            cells: [filterRow]
        )
    }
    
    private func makeFinancialSummarySection() -> FormSection {
        FormSection(
            id: Tags.Section.financialSummary.rawValue,
            cells: [financialSummaryRow]
        )
    }
    
    private func makeQuickActionsSection() -> FormSection {
        FormSection(
            id: Tags.Section.quickActions.rawValue,
            cells: [quickActionsRow]
        )
    }
    
    private func makeBusinessMetricsSection() -> FormSection {
        FormSection(
            id: Tags.Section.businessMetrics.rawValue,
            cells: [businessMetricsRow]
        )
    }
    
    private func makeRecentActivitiesSection() -> FormSection {
        FormSection(
            id: Tags.Section.recentActivities.rawValue,
            cells: [recentActivitiesRow]
        )
    }
    
    // MARK: - Update Sections -

    // MARK: - Lazy Rows
    private lazy var  filterRow: FormRow = makeFilterRowRow()
    private lazy var  financialSummaryRow: FormRow = makeFinancialSummaryRow()
    private lazy var  quickActionsRow: FormRow = makeQuickActionsRow()
    private lazy var  businessMetricsRow: FormRow = makeBusinessMetricsRow()
    private lazy var  recentActivitiesRow: FormRow = makeRecentActivitiesRow()
    
    private func makeFilterRowRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .white,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: { [weak self] in
                self?.goToDetails?()
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeFinancialSummaryRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .lightGray,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: {
                
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeQuickActionsRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .lightGray,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: {
                
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeBusinessMetricsRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .lightGray,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: {
                
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeRecentActivitiesRow() -> FormRow {
        let model = TitleDropDownFilterModel(
            title: "Finacial Overview",
            description: nil,
            filterTitle: "This Week",
            filterIcon: .arrowDown,
            backgroundColor: .lightGray,
            cornerRadius: 8,
            isHidden: false,
            onFilterTap: {
                
            }
        )
        
        let row = TitleDropDownFilterFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }


    // MARK: - State
    private struct State {
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
        }
        enum Cells: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            
        }
    }
}
