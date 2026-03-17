//
//  ServicesViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ServicesViewModel: FormViewModel {

    // MARK: - Callbacks
    var onTapMoreServices: (() -> Void)?
    var onTapService: ((TradeServiceResponse) -> Void)?

    // MARK: - Services
    private let servicesService = NetworkEnvironment.shared.servicesService

    // MARK: - State
    private var state = State()

    override init() {
        super.init()
        self.sections = makeSections()
        reloadBodySection(animated: false)
    }

    // MARK: - Fetch
    override func fetchData() {
        showLoader()

        Task {
            async let featured = fetchDataType(.featuredServices)
            async let types = fetchDataType(.serviceProviderTypes)
            async let providers = fetchDataType(.serviceProviders)
            async let logistics = fetchDataType(.logisticsServiceProviders)

            _ = await [featured, types, providers, logistics]

            DispatchQueue.main.async { [weak self] in
                self?.reloadBodySection()
                self?.hideLoader()
            }
        }
    }

    // MARK: - Fetch Helper
    @discardableResult
    private func fetchDataType(_ type: FetchDataType) async -> Bool {
        do {
            switch type {

            case .featuredServices:
                let response = try await servicesService.getFeaturedTradeServices(
                    page: 1,
                    count: 20,
                    accessToken: state.guestToken
                )
                state.featuredServices = response

            case .serviceProviderTypes:
                let response = try await servicesService.getServiceProviderTypes(
                    accessToken: state.guestToken
                )
                state.serviceProviderTypes = response

            case .serviceProviders:
                let response = try await servicesService.getServiceProviders(
                    page: 1,
                    count: 20,
                    productId: "",
                    accessToken: state.guestToken
                )
                state.serviceProviders = response

            case .logisticsServiceProviders:
                let response = try await servicesService.getLogisticsServiceProviders(
                    page: 1,
                    count: 20,
                    productId: "",
                    accessToken: state.guestToken
                )
                state.logisticsServiceProviders = response
            }

            print("✅ Fetched \(type)")
            return true

        } catch {
            print("❌ Error in \(type): \(error)")
            return false
        }
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [
                searchRow,
                segmentedRow
            ]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: []
        )
    }

    // MARK: - Body Switching

    private func reloadBodySection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.body.rawValue
        }) else { return }

        let newCells: [FormRow]

        switch state.selectedSegmentIndex {
        case 0:
            newCells = makeServiceProvidersCells()
        case 1:
            newCells = makeLogisticsCells()
        default:
            newCells = []
        }

        sections[index].cells = newCells
        reloadSection(index)
    }

    // MARK: - Rows

    private lazy var searchRow = SearchFormRow(
        tag: Tags.Cells.search.rawValue,
        model: SearchFormModel(
            placeholder: "Search services",
            keyboardType: .default,
            searchIcon: UIImage(systemName: "magnifyingglass"),
            searchIconPlacement: .right,
            filterIcon: nil,
            didTapSearchIcon: { print("Search tapped") },
            didTapFilterIcon: { print("Filter tapped") }
        )
    )

    private lazy var segmentedRow = makeSegmentedRow()

    private func makeSegmentedRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Services Providers", "Logistics"],
                selectedIndex: state.selectedSegmentIndex,
                tag: Tags.Cells.segment.rawValue,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }
                    self.state.selectedSegmentIndex = index
                    self.reloadBodySection()
                }
            )
        )
    }

    // MARK: - Grid Builders (ALL SEGMENTS)

    private func makeFeaturedServicesCells() -> [FormRow] {
        [makeGridRow(items: state.featuredServices.map { service in
            GridItemModel(
                id: "\(service.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: service.primaryImage ?? "",
                title: service.name ?? "Unnamed",
                subtitle: service.traderName ?? "",
                price: service.price != nil
                    ? "$\(String(format: "%.2f", service.price!))"
                    : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    self?.onTapService?(service)
                },
                onToggleFavorite: { _ in }
            )
        })]
    }

    private func makeServiceProvidersCells() -> [FormRow] {
        [makeGridRow(items: state.serviceProviders.map { provider in
            GridItemModel(
                id: "\(provider.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: provider.profileImageUrl ?? "",
                title: provider.organization ?? "Provider",
                subtitle: provider.description ?? "",
                price: nil,
                isFavorite: false,
                onTap: {
                    print("Tapped provider")
                },
                onToggleFavorite: { _ in }
            )
        })]
    }

    private func makeLogisticsCells() -> [FormRow] {
        [makeGridRow(items: state.logisticsServiceProviders.map { provider in
            GridItemModel(
                id: "\(provider.id ?? 0)",
                image: UIImage(named: "blank_rectangle"),
                imageUrl: provider.displayImage ?? "",
                title: provider.providerName ?? "Logistics",
                subtitle: provider.locationName ?? "",
                price: nil,
                isFavorite: false,
                onTap: {
                    print("Tapped logistics")
                },
                onToggleFavorite: { _ in }
            )
        })]
    }

    // MARK: - Shared Grid Row

    private func makeGridRow(items: [GridItemModel]) -> FormRow {
        GridFormRow(
            tag: 999,
            items: items,
            numberOfColumns: 2,
            useCollectionView: false
        )
    }

    // MARK: - State

    private struct State {
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        var selectedSegmentIndex: Int = 0

        var featuredServices: [TradeServiceResponse] = []
        var serviceProviderTypes: [ServiceProviderTypesResponse] = []
        var serviceProviders: [ServiceProviderResponse] = []
        var logisticsServiceProviders: [LogisitcisServiceProviderResponse] = []
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }

        enum Cells: Int {
            case search = 100
            case segment = 101
        }
    }

    // MARK: - Data Types

    private enum FetchDataType: CustomStringConvertible {
        case featuredServices
        case serviceProviderTypes
        case serviceProviders
        case logisticsServiceProviders

        var description: String {
            switch self {
            case .featuredServices: return "Featured Services"
            case .serviceProviderTypes: return "Service Provider Types"
            case .serviceProviders: return "Service Providers"
            case .logisticsServiceProviders: return "Logistics Providers"
            }
        }
    }
}
