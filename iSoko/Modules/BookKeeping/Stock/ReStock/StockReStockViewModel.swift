//
//  StockReStockViewModel.swift
//  
//
//  Created by Edwin Weru on 18/07/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class StockReStockViewModel: FormViewModel {

    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    var goToShowSuccessScreen: (() -> Void)?

    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    private var state: State

    init(_ item: StockResponse) {
        state = State(item: item)

        super.init()

        sections = makeSections()
    }

    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    dateRow,
                    quantityRow,
                    SpacerFormRow(tag: 10),
                    continueButtonRow
                ]
            )
        ]
    }

    private lazy var quantityRow = SimpleInputFormRow(
        tag: CellTag.quantity.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Quantity",
                keyboardType: .numberPad
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Quantity",
            useCardStyle: true,
            onTextChanged: { [weak self] value in
                self?.state.quantity = value
            }
        )
    )

    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "common.label.date".localized,
            placeholder: state.dateString,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }

                self.goToDateSelection(.year()) { date in
                    guard let date else { return }

                    self.state.date = date
                    self.state.dateString = Helpers.format(date)

                    self.reloadRow(withTag: CellTag.date.rawValue)
                }
            }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Restock",
            style: .primary,
            size: .medium
        ) { [weak self] in
            Task {
                await self?.submit()
            }
        }
    )

    private func submit() async {
        guard let quantity = Int(state.quantity) else {
            showError("Please enter a valid quantity")
            return
        }

        let item = state.item

        let params: [String: Any] = [
            "id": item.id ?? -1,

            "name": item.name ?? "",
            "description": item.description ?? "",

            "price": item.price ?? 0,
            "quantity": quantity,
            "minimumOrderQuantity": item.minimumOrderQuantity ?? quantity,

            "lowStockThreshold": item.lowStockThreshold ?? 0,

            "supplierId": item.supplier?.id ?? item.trader?.id ?? 0,
            "measurementUnitId": item.measurementUnit?.id ?? 0,

            "inStock": item.inStock ?? false,
            "published": item.published ?? false,
            "active": item.active ?? false,
            "approved": item.approved ?? false,
            "featured": item.featured ?? false
        ]

        let success = await updateStock(parameters: params)

        if success {
            goToShowSuccessScreen?()
        }
    }

    private func updateStock(parameters: [String: Any]) async -> Bool {
        do {
            _ = try await bookKeepingService.updateProduct(
                itemId: state.item.id ?? -1,
                parameters: parameters,
                accessToken: state.oauthToken
            )

            return true

        } catch let NetworkError.server(response) {
            showError(response.alertMessage)
            return false

        } catch {
            print("❌ Error updating stock:", error)
            showError(error.localizedDescription)
            return false
        }
    }

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    private struct State {
        let item: StockResponse

        var date: Date
        var dateString: String
        var quantity: String = ""

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""

        init(item: StockResponse) {
            self.item = item
            self.date = Date()
            self.dateString = Helpers.format(Date())
        }
    }

    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case date
        case quantity
        case continueButton
    }
}
