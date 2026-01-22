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
            cells: [quickActionsRow, quickActionsNoTitleRow]
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
    private lazy var  quickActionsNoTitleRow: FormRow = makeQuickNoTitleActionsRow()
    
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
        let leftCard = CardModel(
            title: "Balance",
            titleIcon: UIImage(systemName: "wallet.pass"),
            description: "$1,240.00",
            statusModel: StatusCardViewModel(
                title: "200 percent",
                image: .stockmarketArrowUp,
                backgroundColor: .systemGreen.withAlphaComponent(0.1)
            ),
            backgroundColor: .systemGreen.withAlphaComponent(0.1),
            onTap: { [weak self] in
               // self?.openBalance()
            }
        )
        
        let rightCard = CardModel(
            title: "Transactions",
            titleIcon: UIImage(systemName: "list.bullet"),
            description: "View history",
            statusModel: StatusCardViewModel(
                title: "200 percent",
                image: .stockmarketArrowDown,
                backgroundColor: .systemRed.withAlphaComponent(0.1)
            ),
            backgroundColor: .systemOrange.withAlphaComponent(0.1),
            onTap: { [weak self] in
               // self?.openTransactions()
            }
        )
        
        let model = TwoCardsModel(
            leftCard: leftCard,
            rightCard: rightCard
        )

        let row = TwoCardsFormRow(tag: Tags.Cells.financialSummary.rawValue, model: model)
        return row
    }
    
    private func makeQuickActionsRow() -> FormRow {
        let payBill = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemBlue,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56
        )
        
        let transfer = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemBlue,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80
        )

        let row = TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                title: "Quick Actions",
                description: "Common things you can do",
                cards: TwoStatusCardsViewModel(
                    first: payBill,
                    second: transfer,
                    layout: .horizontal
                )
            )
        )
        return row
    }
    
    private func makeQuickNoTitleActionsRow() -> FormRow {
        let payBill = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemRed,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56
        )
        
        let transfer = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemGreen,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80
        )

        let row = TwoCardsSummaryFormRow(
            tag: 200,
            model: TwoCardsSummaryViewModel(
                cards: TwoStatusCardsViewModel(
                    first: payBill,
                    second: transfer,
                    layout: .horizontal
                )
            )
        )
        return row
    }
    
    private func makeBusinessMetricsRow() -> FormRow {
        
        let quickAction1 = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemBlue,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 56
        )
        
        let quickAction2 = StatusCardViewModel(
            title: "Pay Bills",
            image: UIImage(systemName: "bolt.fill"),
            backgroundColor: .systemBlue,
            iconTintColor: .white,
            textColor: .white,
            iconSize: CGSize(width: 28, height: 28),
            fixedHeight: 80
        )
        
        let row = TwoStatusCardsFormRow(
            tag: 101,
            model: TwoStatusCardsViewModel(
                first: quickAction1,
                second: quickAction2,
                layout: .horizontal
            )
        )
        
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
