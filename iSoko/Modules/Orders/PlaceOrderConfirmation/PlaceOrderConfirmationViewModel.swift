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
    // MARK: - Callbacks
    var onSuccess: ((OrderResponse) -> Void)?
    var onFailure: ((String) -> Void)?
    var gotoConfirm: (() -> Void)? = { }
    
    private let countryHelper = CountryHelper()
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    private let ordersService = NetworkEnvironment.shared.ordersService
    
    // MARK: - State
    private var state: State
    
    // MARK: - Init
    init(_ order: PlaceOrderPayload) {
        
        self.state = State(
            order: order,
            quantity: max(order.quantity, order.minimumQuantity)
        )
        
        super.init()
        
        sections = makeSections()
    }
    
    // MARK: - Pricing (single source of truth)
    
    private func unitPrice() -> Double {
        state.order.unitPrice ?? state.order.product.price ?? 0
    }
    
    private var subtotal: Double {
        unitPrice() * Double(state.quantity)
    }
    
    private var total: Double {
        subtotal
    }
    
    // MARK: - Sections
    
    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeItemSection(),
            makeDescriptionSection(),
            makeSummarySection(),
            makeActionSection()
        ]
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: SectionTag.header.rawValue,
            cells: [
                SpacerFormRow(tag: 1),
                titleDescriptionFormRow,
                SpacerFormRow(tag: 1)
            ]
        )
    }
    
    private func makeItemSection() -> FormSection {
        FormSection(
            id: SectionTag.item.rawValue,
            cells: [
                makeOrderItemRow()
            ]
        )
    }
    
    private func makeDescriptionSection() -> FormSection {
        FormSection(
            id: SectionTag.description.rawValue,
            cells: [
                SpacerFormRow(tag: 2),
                descriptionRow
            ]
        )
    }
    
    private func makeSummarySection() -> FormSection {
        FormSection(
            id: SectionTag.summary.rawValue,
            cells: [
                SpacerFormRow(tag: 3),
                makeOrderSummaryRow()
            ]
        )
    }
    
    private func makeActionSection() -> FormSection {
        FormSection(
            id: SectionTag.actions.rawValue,
            cells: [
                SpacerFormRow(tag: 4),
                continueButtonRow
            ]
        )
    }
    
    // MARK: - Order Item Row
    
    private func makeOrderItemRow() -> FormRow {
        
        let order = state.order
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        let unitPrice = unitPrice()
        
        let vm = OrderConfirmItemViewModel(
            id: order.product.id ?? 0,
            title: order.product.name ?? "Unnamed Product",
            subtitle: order.product.traderFullName ?? "Unknown Seller",
            currency: currency,
            pricePerUnit: Decimal(unitPrice),
            quantity: state.quantity,
            minimumQuantity: order.minimumQuantity,
            onUpdate: { [weak self] updated in
                guard let self else { return }
                
                self.state.quantity = updated.quantity
                
                Task { @MainActor in
                    self.rebuildSummarySection()
                }
            }
        )
        
        return OrderConfirmItemFormRow(
            tag: CellTag.orderItem.rawValue,
            viewModel: vm
        )
    }
    
    // MARK: - Summary Row
    
    private func makeOrderSummaryRow() -> FormRow {
        
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
        
        let rows: [OrderBreakdownRowModel] = [
            OrderBreakdownRowModel(
                title: "Unit Price",
                value: Helpers.formatCurrency(unitPrice(), currency: currency),
                isHighlighted: false
            ),
            OrderBreakdownRowModel(
                title: "Quantity",
                value: "\(state.quantity)",
                isHighlighted: false
            ),
            OrderBreakdownRowModel(
                title: "Subtotal",
                value: Helpers.formatCurrency(subtotal, currency: currency),
                isHighlighted: true
            )
        ]
        
        return OrderBreakdownFormRow(
            tag: CellTag.summary.rawValue,
            model: OrderBreakdownModel(
                title: "Order Summary",
                rows: rows,
                totalTitle: "Total",
                totalValue: Helpers.formatCurrency(total, currency: currency)
            )
        )
    }
    
    // MARK: - Description Row
    
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
            titleText: "Message to the seller",
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )
    
    // MARK: - Header Row
    
    private lazy var titleDescriptionFormRow: FormRow = makeTitleRow(
        title: "Products",
        description: ""
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
    
    // MARK: - Button
    
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "common.button.continue".localized,
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )
    
    // MARK: - FIXED RELOAD (NO makeSections CALL)
    
    private func rebuildSummarySection() {
        
        guard let index = sections.firstIndex(where: { $0.id == SectionTag.summary.rawValue }) else {
            return
        }
        
        sections[index] = makeSummarySection()
        reloadSection(SectionTag.summary.rawValue)
    }
    
    // MARK: - Submit
    private func submit() async {
        let success = await performOrderRequest()
        
        guard success, let response = state.lastResponse else {
            return
        }
        
        onSuccess?(response)
        gotoConfirm?()
    }
    
    @discardableResult
    private func performOrderRequest() async -> Bool {
        showLoader()
        defer { hideLoader() }
        
        let product = state.order.product
        
        guard
            let productId = product.id,
            let sellerId = product.trader?.id
        else {
            onFailure?("Invalid product data")
            return false
        }
        
        // ✅ FIX: prevent self-order (backend rule)
        let buyerId = state.userProfile?.id ?? 0
        if sellerId == buyerId {
            onFailure?("You cannot order your own product")
            return false
        }
        
        let products = [
            OrderProductRequest(
                productId: productId,
                quantity: state.quantity
            )
        ]
        
        do {
            let response = try await ordersService.placeOrder(
                sellerId: sellerId,
                comment: state.description,
                products: products,
                accessToken: AppStorage.oauthToken?.accessToken ?? ""
            )
            
            state.lastResponse = response
            return true
            
        } catch let NetworkError.server(response) {
            onFailure?(response.alertMessage)
            return false
            
        } catch {
            onFailure?(error.localizedDescription)
            return false
        }
    }
    
    // MARK: - State
    
    private struct State {
        var lastResponse: OrderResponse?
        let order: PlaceOrderPayload
        var quantity: Int
        var description: String = ""
        
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile
    }
    
    // MARK: - Tags
    
    private enum SectionTag: Int {
        case header = 0
        case item = 1
        case description = 2
        case summary = 3
        case actions = 4
    }
    
    private enum CellTag: Int {
        case orderItem = 10
        case description = 12
        case continueButton = 9
        case summary = 13
    }
}
