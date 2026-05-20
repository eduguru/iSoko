//
//  TradeAssociationCoordinator.swift
//
//
//  Created by Edwin Weru on 09/02/2026.
//

import RouterKit
import UIKit
import StorageKit

@MainActor
final class TradeAssociationFlowCoordinator: BaseCoordinator {

    // Router that will point to the modal nav for pushes inside this flow
    private var modalRouter: Router?

    override func start() {
        gotoTradeAssociations()
    }

    // MARK: - Main Dashboard
    private func gotoTradeAssociations() {
        guard AppStorage.hasLoggedIn ?? false else {
            presentAuthBottomSheet()
            return
        }

        let viewModel = TradeAssociationListingsViewModel()
        viewModel.goToMoreDetails = gotoTradeAssociationDetails

        viewModel.goToButtonAction = { [weak self] actionTitle, item, completion in
            guard let self else { return }

            let message = "Are you sure you want to \(actionTitle.lowercased()) \(item.name ?? "")?"
            self.presentConfirmaionAlert(
                title: actionTitle,
                message: message,
                onConfirm: { completion(true) },
                onCancel: { completion(false) }
            )
        }

        let vc = TradeAssociationListingsViewController()
        vc.viewModel = viewModel
        vc.goToCreateAction = { [weak self] in
            self?.gotoCreateTradeAssociations()
        }
        vc.closeAction = { [weak self] in
            self?.dismiss()
        }

        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen

        // Present modally from top view controller in main flow
        if let top = router.topViewController() {
            top.present(nav, animated: true)
            // Set modalRouter for pushes inside modal flow
            self.modalRouter = Router(navigationController: nav)
        }
    }

    // MARK: - Trade Association Details
    private func gotoTradeAssociationDetails(_ data: AssociationResponse) {
        guard let router = modalRouter else { return }

        let viewModel = TradeAssociationDetailsViewModel(data)
        viewModel.goToNewsDetails = goToNewsDetails

        let vc = TradeAssociationDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    // MARK: - Create Trade Associations
    private func gotoCreateTradeAssociations() {
        guard let router = modalRouter else { return }

        let modalCoordinator = ModalCoordinator(router: router)
        addChild(modalCoordinator)

        let viewModel = NewTradeAssociationViewModel()
        viewModel.goToDateSelection = gotoSelectDate
        viewModel.gotoSelectSystemCountry = gotoSelectSystemCountry
        viewModel.onStep1Complete = gotoCompleteCreateTradeAssociations

        let vc = NewTradeAssociationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    private func gotoCompleteCreateTradeAssociations(_ data: [String: Any]) {
        guard let router = modalRouter else { return }

        let viewModel = CompleteNewTradeAssociationViewModel(data)
        let vc = CompleteNewTradeAssociationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    // MARK: - Date / Country Selection
    func gotoSelectDate(config: DatePickerConfig, completion: @escaping (Date?) -> Void) {
        guard let router = modalRouter else { return }
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)

        coordinator.goToAppleStyleCalendar(config: config) { result in
            completion(result)
        }
    }

    func gotoSelectSystemCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
        guard let router = modalRouter else { return }

        let viewModel = CommonOptionPickerViewModel(option: type)
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .countries(let response):
                completion(response)
            default:
                completion(nil)
            }
            self?.modalRouter?.pop(animated: true)
        }

        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    // MARK: - News Details
    private func goToNewsDetails(_ item: AssociationNewsItem) {
        guard let router = modalRouter else { return }

        let viewModel = NewsDetailsViewModel(item.toDomain())
        let vc = NewsDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    // MARK: - Helpers
    private func dismiss() {
        modalRouter?.navigationControllerInstance?.dismiss(animated: true)
        modalRouter = nil
        parentCoordinator?.removeChild(self)
    }

    private func showLoginFlow() {
        AppStorage.hasShownInitialLoginOptions = false

        let nav = BaseNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = AuthCoordinator(router: router)

        addChild(coordinator)
        coordinator.start()

        nav.modalPresentationStyle = .fullScreen
        self.router.present(nav, animated: true)
    }

    private func presentAuthBottomSheet() {
        guard let topVC = router.topViewController() else { return }

        AuthBottomSheet.present(
            from: topVC,
            onLogin: { [weak self] in
                self?.showLoginFlow()
            },
            onGuest: {
                RuntimeSession.authState = .guest
                AppStorage.hasLoggedIn = false
            }
        )
    }

    func goToShowSuccessScreen() {
        guard let router = modalRouter else { return }
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)

        coordinator.presentSuccessAlert { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }
    }

    func goToShowErrorScreen() {
        guard let router = modalRouter else { return }
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)

        coordinator.presentErrorAlert(
            onPrimaryAction: { [weak self] in
                self?.modalRouter?.pop(animated: true)
            },
            onSecondaryAction: { [weak self] in
                self?.modalRouter?.pop(animated: true)
            }
        )
    }

    func presentConfirmaionAlert(title: String, message: String?, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        let coordinator = ModalCoordinator(router: modalRouter ?? router)
        addChild(coordinator)

        coordinator.presentConfirmationBottomSheet(
            title: title,
            message: message,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
}

//MARK: -

extension TradeAssociationFlowCoordinator {
    func goToTradeAssociationProducs(_ association: AssociationResponse) {
        
        let viewModel = AssociationProductsViewModel(association)
        viewModel.goToMoreDetails = gotoTradeAssociationDetails
        viewModel.goToProductDetails = goToProduct

        let vc = AssociationProductsViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.dismiss()
        }

        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen

        // Present modally from top view controller in main flow
        if let top = router.topViewController() {
            top.present(nav, animated: true)
            // Set modalRouter for pushes inside modal flow
            self.modalRouter = Router(navigationController: nav)
        }
    }
    
    private func goToProduct(_ product: ProductResponseV1) {

        guard let router = modalRouter else { return }

        let viewModel = ProductDetailsViewModel(product)

        let vc = ProductDetailsViewController()
        vc.viewModel = viewModel

        vc.closeAction = { [weak self] in
            self?.modalRouter?.pop(animated: true)
        }

        // chain navigation inside product flow
        viewModel.onProductTap = { [weak self] tappedProduct in
            self?.goToProduct(tappedProduct)
        }

        viewModel.onToggleFavorite = { tappedProduct, isFav in
            print("\(tappedProduct.name ?? "") favorite toggled: \(isFav)")
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }
}
