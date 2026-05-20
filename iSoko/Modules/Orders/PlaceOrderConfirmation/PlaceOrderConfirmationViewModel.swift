//
//  PlaceOrderConfirmationViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class PlaceOrderConfirmationViewModel: FormViewModel {
    var gotoConfirm: (() -> Void)? = { }
    
    @MainActor private let countryHelper = CountryHelper()

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        
        Task { @MainActor in
            
            sections = makeSections()
        }
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    SpacerFormRow(tag: 20),
                    descriptionRow,
                ]
            )
        ]
    }

    // MARK: - Rows
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue,
            model: TitleDescriptionModel(
                title: title,
                description: description,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .body,
                descriptionFontStyle: .subheadline
            )
        )
    }
    
    // Description input (multiline)  RichDescriptionFormRow LongInputDescriptionFormRow
    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "",
                accessoryImage: nil,
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "common.label.description".localized,
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: {[weak self] newText in
                self?.state.description = newText
            },
            onValidationError: { error in
                if let error = error {
                    print("Validation error: \(error)")
                }
            }
        )
    )
    
    // MARK: - Reload // MARK: - Helpers
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
        var description: String = ""
        
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
        case description = 12
    }
}
