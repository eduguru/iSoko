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

    private var state: State

    // MARK: - Services
    private let productsService = NetworkEnvironment.shared.productsService
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let productsSuccess = await fetchProductItems()
            
            if !productsSuccess {
                print("⚠️ Failed to fetch one or product types.")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateMoreProductsFromSellerSection()
                self.updateSimilarProductsSection()
            }
        }
    }

    // MARK: - makeSections
    
    private func makeSections() -> [FormSection] {
        return [
            moreProductsFromSellerSection(),
            similarProductsSection()
        ]
    }
    
    private func moreProductsFromSellerSection() -> FormSection {
        return FormSection(
            id: Tags.Section.moreFromThisSeller.rawValue,
            title: "More From This Seller",
            cells: [moreFromThisSellerFormRow]
        )
    }
    
    private func similarProductsSection() -> FormSection {
        return FormSection(
            id: Tags.Section.similarProducts.rawValue,
            title: "Similar Products",
            cells: [similarProductsFormRow]
        )
    }
    
    private func updateMoreProductsFromSellerSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.moreFromThisSeller.rawValue }) else {
            return
        }

        let updatedRow = HorizontalGridFormRow(
            tag: Tags.Section.moreFromThisSeller.rawValue,
            items: makeMoreFromSellerGridItems()
        )

        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }

    private func updateSimilarProductsSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.similarProducts.rawValue }) else {
            return
        }

        let updatedRow = HorizontalGridFormRow(
            tag: Tags.Section.similarProducts.rawValue,
            items: makeSimilarProductsGridItems()
        )

        var updatedSection = sections[sectionIndex]
        updatedSection.cells = [updatedRow]
        sections[sectionIndex] = updatedSection
        reloadSection(sectionIndex)
    }
    
    // MARK: - Lazy Rows
    private lazy var moreFromThisSellerFormRow = HorizontalGridFormRow(tag: 300,items: [])
    private lazy var similarProductsFormRow = HorizontalGridFormRow(tag: 300, items: [])
    
    // MARK: - Builders

    private func makeMoreFromSellerGridItems() -> [GridItemModel] {
        return state.moreOwnerProducts.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self = self else { return }
                },
                onToggleFavorite: { isFav in
                }
            )
        }
    }

    private func makeSimilarProductsGridItems() -> [GridItemModel] {
        return state.similarProduct.map { product in
            GridItemModel(
                id: "\(product.id ?? 0)",
                image: UIImage(named: "logo"),
                imageUrl: product.primaryImage ?? "",
                title: product.name ?? "Unnamed Product",
                subtitle: product.traderName ?? "",
                price: product.price != nil ? "$\(String(format: "%.2f", product.price!))" : nil,
                isFavorite: false,
                onTap: { [weak self] in
                    guard let self = self else { return }
                    print("Tapped similar product: \(product.name ?? "")")
                },
                onToggleFavorite: { isFav in
                    print("Favorite toggled (\(isFav)) for similar product: \(product.name ?? "")")
                }
            )
        }
    }

    
    //MARK: - Network Calls -
    private func fetchProductItems() async -> Bool {
        async let moreOwnerProducts = fetchData(type: .moreOwnerProducts)
        async let similarProduct = fetchData(type: .similarProduct)

        let results = await [moreOwnerProducts, similarProduct]
        return results.allSatisfy { $0 }
    }
    
    @discardableResult
    private func fetchData(type: RequestDataType) async -> Bool {
        do {
//            switch type {
//            case .moreOwnerProducts:
//                let traderId = state.product.categoryId ?? 0
//                let response = try await productsService.getProductsByCategory(page: 1, count: 10, categoryId: "\(traderId)", accessToken: state.accessToken)
//                self.state.moreOwnerProducts = response
//                print("✅ Fetched Featured Products")
//
//            case .similarProduct:
//                let traderId = state.product.categoryId ?? 0
//                let response = try await productsService.getProductsByCategory(page: 1, count: 10, categoryId: "\(traderId)", accessToken: state.accessToken)
//                self.state.similarProduct = response
//                print("✅ Fetched Featured Services")
//            }
            
            return true

        } catch let NetworkError.server(apiError) {
            print("❌ API Error in \(type):", apiError.message ?? "")
        } catch {
            print("❌ Unexpected Error in \(type):", error)
        }
        return false
    }
    
    // MARK: - Data Types

    private enum RequestDataType: CustomStringConvertible {
        case similarProduct
        case moreOwnerProducts

        var description: String {
            switch self {
            case .similarProduct: return "Logistics Services"
            case .moreOwnerProducts: return "Service Providers"
            }
        }
    }

    // MARK: - State

    private struct State {
        var accessToken = AppStorage.authToken?.accessToken ?? ""
        var similarProduct: [ProductResponse] = []
        var moreOwnerProducts: [ProductResponse] = []
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
            case similarProducts = 5
            case moreFromThisSeller = 6
        }

        enum Cells: Int {
            case productImages = 0
            case titleAndDescription = 1
            case price = 2
            case categories = 3
        }
    }
}
