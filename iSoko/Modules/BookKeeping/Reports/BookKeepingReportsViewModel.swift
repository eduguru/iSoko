//
//  BookKeepingReportsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class BookKeepingReportsViewModel: FormViewModel {
    var gotoConfirm: (() -> Void)?

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    selectionInputRow,
                    SpacerFormRow(tag: 20),
                ]
            )
        ]
    }

    // MARK: - Rows

    private lazy var selectionInputRow = makeSelectionGrid()
    
    private func makeSelectionGrid() -> FormRow {
        
        SelectableCardGridRow(
            tag: 1,
            config: .init(
                items: [
                    .init(title: "Sales", subtitle: "Track revenue", icon: UIImage(systemName:"chart.line.uptrend.xyaxis")),
                    .init(title: "Expenses", subtitle: "Monitor spending", icon: UIImage(systemName:"calendar")),
                    .init(title: "Stock", subtitle: "Inventory levels", icon: UIImage(systemName:"archivebox")),
                    .init(title: "Profit & Loss", subtitle: "Financial performance", icon: UIImage(systemName:"chart.bar")),
                    .init(title: "Customers", subtitle: "Top buyers", icon: UIImage(systemName:"person.2")),
                    .init(title: "Suppliers", subtitle: "Vendors", icon: UIImage(systemName:"truck.box"))
                ],
                allowsMultipleSelection: false
            )
        )
    }

    // MARK: - handle selections
    

    // MARK: - Reload
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Submit
    private func submit() async {

    }

    // MARK: - State
    private struct State {
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case category = 4
        case continueButton = 9
    }
}


