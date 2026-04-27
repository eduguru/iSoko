//
//  AddExpenseCategoryViewModel.swift
//  
//
//  Created by Edwin Weru on 14/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class AddExpenseCategoryViewModel: FormViewModel {
    
    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?
    
    var goToAddCategorySuccess: ((SupplierCategoryResponse) -> Void)? = { _ in }
    var goToSelectExpenseCategory: (() -> Void)? = { }
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        
    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        showLoader()
        
        do {
            let response = try await bookKeepingService.addExpenseCategories(name: state.name, accessToken: state.oauthToken)
                
            state.SupplierCategory = response
            goToAddCategorySuccess?(response)
            hideLoader()
            goToShowSuccessScreen?()
            return true
            
        } catch {
            hideLoader()
            print("❌ Error: ", error)
            return false
        }
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    titleFormRow,
                    SpacerFormRow(tag: 10, height: 16),
                    nameInputRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var nameInputRow = makeInputRow(
        tag: CellTag.supplierName.rawValue,
        title: "Enter Category name",
        placeholder: "Enter Category name",
        keyboard: .default
    )
    
    private lazy var titleFormRow: FormRow = makeTitleRow(
        title: "Add a new Category",
        description: "Enter a unique name for the new category to help organize your Expense catalog"
    )
    
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue,
            model: TitleDescriptionModel(
                title: title,
                description: description,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .headline,
                descriptionFontStyle: .subheadline
            )
        )
    }
    // MARK: - Row Builder

    private func makeInputRow(
        tag: Int,
        title: String,
        placeholder: String,
        keyboard: UIKeyboardType
    ) -> SimpleInputFormRow {

        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: keyboard
                ),
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }

                    switch tag {

                    case CellTag.supplierName.rawValue:
                        self.state.name = newText

                    default:
                        break
                    }
                }
            )
        )
    }

    // MARK: - Button

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Proceed",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task {
                await self?.submit()
            }
        }
    )

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
        Task {
            let success = await performNetworkRequest()
            
            if !success {
                print("Failed to fetch add supplier category data")
            }
        }
    }

    // MARK: - State
    private struct State {
        var name: String = ""
        var SupplierCategory: SupplierCategoryResponse?

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Tags

    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case continueButton = 0
        case supplierName = 1
        case categoryRow = 7
    }
}
