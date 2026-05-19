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
    func goToEditAction() {  goToEdit?(state.item) }
    
    private var state: State
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()
    
    init(_ item: CustomerOrderResponse) {
        state = State(item: item)
        
        super.init()
        
        Task { @MainActor in
            self.sections = makeSections()
        }
    }
    
    // MARK: - Fetch
    override func fetchData() { }
    
    // MARK: - Sections -
    private func makeSections() -> [FormSection] {
        [
            makeProfileSection(),
            makeOrderSummarySection(),
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
    
    private func makeStoreProfileSection() -> FormSection {
        FormSection(
            id: Tags.Section.storeProfile.rawValue,
            cells: [storeProfileRow]
        )
    }
    
    
    
    // MARK: - Update Sections -
    
    // MARK: - Lazy Rows
    private lazy var  statusRow: FormRow = makeStatusInfoRow()
    // private lazy var  profileRow: FormRow = makeProfileInfoRow()
    private lazy var storeProfileRow: FormRow = makeStoreProfileRow()
    
    private func makeStatusInfoRow() -> FormRow {
        let model = StatusCardModel(
            title: "Order Status",
            subtitle: "Awaiting Fulfillment",
            statusText: state.item.displayStatus,
            statusStyle: StatusStyle(textColor: .offWhite, backgroundColor: state.item.statusColor),
            card: .default.with(borderColor: .clear)
        )
        
        let row = StatusCardFormRow(tag: Tags.Cells.filter.rawValue, model: model)
        return row
    }
    
    private func makeProfileInfoRow() -> FormRow {
        let model = ProfileInfoCellConfig(
            name: state.item.orderNumber ?? "Order Number: N/A",  // Default name if customer name is nil
            infoItems: [
                // Using the correct SF Symbols for each piece of info
                makeInfoItem(state.item.buyerFullName ?? "Customer: N/A", icon: "person.fill"), // Customer name with person icon
                makeInfoItem(state.item.datetimeCreated ?? "Description: N/A", icon: "doc.text.fill"), // Description or email with a document icon
                makeInfoItem(state.item.displayStatus ?? "Status: N/A", icon: "creditcard.fill") // Payment method with credit card icon
            ],
            onEditTap: {
                // Handle the edit action here
            }
        )
        
        let row = ProfileInfoRow(tag: Tags.Cells.filter.rawValue, config: model)
        return row
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
    
    private func makeStoreProfileRow() -> FormRow {
        
        let traderName = state.item.sellerFullName
        let phoneNumber = state.item.seller.phoneNumber ?? "0000000000"
        let email = state.item.seller.email ?? ""
        let whatsappNumber = state.item.seller.whatsappNumber ?? "0000000000"
        
        return StoreProfileCardRow(
            tag: Tags.Cells.storeProfile.rawValue,
            config: StoreProfileCardConfig(
                image: .blankRectangle,
                headerTitle: "Seller Details",
                title: traderName,
                description: state.item.seller.email,
                verifiedImage: nil,
                badges: [],
                trailingButtonTitle: nil,
                onTrailingButtonTap: {
                    print("Go to seller: \(traderName)")
                },
                actions: [
                    .init(
                        title: "WhatsApp",
                        image: UIImage(systemName: "message.fill"),
                        handler: { print("WhatsApp tapped") }
                    ),
                    .init(
                        title: "Call",
                        image: UIImage(systemName: "phone.fill"),
                        handler: { print("Call tapped") }
                    ),
                    .init(
                        title: "Email",
                        image: UIImage(systemName: "envelope.fill"),
                        handler: { print("Email tapped") }
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
        
        var items: [StockResponse] = []
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

