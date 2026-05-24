//
//  MyOrderDetailsViewModel.swift
//
//
//  Created by Edwin Weru on 01/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class MyOrderDetailsViewModel: FormViewModel {
    var goToDetails: (() -> Void)? = { }
    
    var goToEdit: ((CustomerOrderResponse) -> Void)? = { _ in }
    func goToEditAction() { goToEdit?(state.item) }
    
    private var state: State
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    private let ordersService = NetworkEnvironment.shared.ordersService
    
    @MainActor private let countryHelper = CountryHelper()
    
    init(_ item: CustomerOrderResponse) {
        state = State(item: item)
        super.init()
        
        Task { @MainActor in
            self.sections = makeSections()
        }
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            await fetchOrderProducts()
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.sections = self.makeSections()
            }
        }
    }
    
    // MARK: - Fetch Products
    private func fetchOrderProducts() async {
        do {
            let response = try await ordersService.getOrderProducts(
                orderId: state.item.id,
                page: 1,
                count: 5,
                accessToken: state.oauthToken
            )
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.state.products = response
            }
            
        } catch {
            print("❌ Failed to fetch order products:", error)
        }
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeProfileSection(),
            makeOrderSummarySection(),
            makeProductsSection(),
            makeStoreProfileSection()
        ]
    }
    
    private func makeProfileSection() -> FormSection {
        FormSection(
            id: Tags.Section.filter.rawValue,
            cells: [statusRow]
        )
    }
    
    private func makeOrderSummarySection() -> FormSection {
        FormSection(
            id: Tags.Section.orderSummary.rawValue,
            cells: makeOrderSummaryRow()
        )
    }
    
    private func makeProductsSection() -> FormSection {
        FormSection(
            id: Tags.Section.products.rawValue,
            cells: makeProductRows()
        )
    }
    
    private func makeStoreProfileSection() -> FormSection {
        FormSection(
            id: Tags.Section.storeProfile.rawValue,
            cells: [storeProfileRow]
        )
    }
    
    // MARK: - Rows
    private lazy var statusRow: FormRow = makeStatusInfoRow()
    private lazy var storeProfileRow: FormRow = makeStoreProfileRow()
    
    private func makeStatusInfoRow() -> FormRow {
        let model = StatusCardModel(
            title: "Order Status",
            subtitle: "Awaiting Fulfillment",
            statusText: state.item.displayStatus,
            statusStyle: StatusStyle(
                textColor: .offWhite,
                backgroundColor: state.item.statusColor
            ),
            card: .default.with(borderColor: .clear)
        )
        
        return StatusCardFormRow(
            tag: Tags.Cells.filter.rawValue,
            model: model
        )
    }
    
    private func makeOrderSummaryRow() -> [FormRow] {
        let items: [KeyValueRowModel] = [
            KeyValueRowModel(
                leftText: "Order Date",
                rightText: state.item.datetimeCreated
            ),
            KeyValueRowModel(
                leftText: "Order Number",
                rightText: "#\(state.item.orderNumber)",
                usesMonospacedDigits: true
            ),
            KeyValueRowModel(
                leftText: "Payment Method",
                rightText: "Card"
            )
        ]
        
        let group = KeyValueGroupFormRow(
            tag: 1,
            model: KeyValueGroupModel(
                sectionTitle: "Order Information",
                card: .default.with(borderColor: .clear),
                rows: items
            )
        )
        
        return [group]
    }
    
    private func makeProductRows() -> [FormRow] {
        state.products.map { product in
            
            let vm = OrderConfirmItemViewModel(
                id: product.product.id ?? 0,
                title: product.product.name ?? "Unnamed Product",
                subtitle: state.item.sellerFullName,
                currency: "KES",
                pricePerUnit: Decimal(product.unitPrice ?? 0),
                quantity: product.quantity ?? 0,
                minimumQuantity: product.quantity ?? 0,
                onUpdate: { _ in }
            )
            
            return OrderConfirmItemFormRow(
                tag: product.product.id ?? UUID().hashValue,
                viewModel: vm
            )
        }
    }
    
    private func makeStoreProfileRow() -> FormRow {
        let traderName = state.item.sellerFullName
        let phoneNumber = state.item.seller.phoneNumber ?? "0000000000"
        let email = state.item.seller.email ?? ""
        let whatsappNumber = state.item.seller.whatsappNumber ?? "0000000000"
        
        return StoreProfileCardRow(
            tag: 400,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                title: traderName,
                verifiedImage: nil,
                badges: [],
                trailingButtonTitle: "View Store",
                onTrailingButtonTap: { [weak self] in
                    if let url = URL(string: self?.state.item.seller.storeUrl ?? "") {
                        UIApplication.shared.open(url)
                    }
                },
                actions: [
                    .init(
                        title: "WhatsApp",
                        image: UIImage(systemName: "message.fill"),
                        handler: {
                            let url = URL(string: "https://wa.me/\(whatsappNumber)")!
                            UIApplication.shared.open(url)
                        }
                    ),
                    .init(
                        title: "Call",
                        image: UIImage(systemName: "phone.fill"),
                        handler: {
                            if let url = URL(string: "tel://\(phoneNumber)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    ),
                    .init(
                        title: "Email",
                        image: UIImage(systemName: "envelope.fill"),
                        handler: {
                            if let url = URL(string: "mailto:\(email)") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                ],
                cornerRadius: 20,
                backgroundColor: .systemBackground,
                borderColor: .systemGray5,
                borderWidth: 1
            )
        )
    }
    
    private func makeInfoItem(_ text: String?, icon: String) -> InfoItem {
        InfoItem(text: text, icon: UIImage(systemName: icon))
    }
    
    // MARK: - State
    private struct State {
        var item: CustomerOrderResponse
        
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userProfile: UserDetails? = AppStorage.userDetail
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var products: [OrderProductResponse] = []
    }
    
    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            case orderSummary
            case products
            case storeProfile
        }
        
        enum Cells: Int {
            case filter = 0
            case financialSummary = 1
            case quickActions = 2
            case businessMetrics = 3
            case recentActivities = 4
            case orderSummary
            case storeProfile
        }
    }
}
