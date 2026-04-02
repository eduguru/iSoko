//
//  MyProductDetailsViewModel.swift
//
//
//  Created by Edwin Weru on 01/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class MyProductDetailsViewModel: FormViewModel {
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: -
    private var state = State()
    
    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        sections.append(makeSummarySection())
        
        return sections
    }
    
    private func makeSummarySection() -> FormSection {
        FormSection(
            id: SectionTag.summary.rawValue,
            title: "Summary",
            cells: summaryRows
        )
    }
    
    // MARK: - Rows
    private lazy var summaryRows = makeSummaryRows()
    
    private func makeSummaryRows() -> [FormRow] {
        return [
            KeyValueFormRow(
                tag: 1,
                model: KeyValueRowModel(
                    leftText: "Subtotal",
                    rightText: "$120",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 2,
                model: KeyValueRowModel(
                    leftText: "Tax",
                    rightText: "$12",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 3,
                model: KeyValueRowModel(
                    leftText: "Total",
                    rightText: "$132",
                    showsTopDivider: true,
                    isEmphasized: true,
                    usesMonospacedDigits: true
                )
            )
        ]
    }
    
    private func reloadBodySection(animated: Bool = true) {
        
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
        case summary = 4
    }
    
    private enum CellTag: Int {
        case summary = 12
        
    }
}


