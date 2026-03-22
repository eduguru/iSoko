//
//  BusinessCoordinator.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import RouterKit
import UtilsKit
import UIKit
import StorageKit

public class BusinessCoordinator: BaseCoordinator {
    
    func primaryViewController() -> BusinessViewController {
        var model = BusinessViewModel()
        model.goToBookKeeping = goToBookKeeping
        
        let controller = BusinessViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    public override func start() {
        router.setRoot(primaryViewController())
        // navigationController?.pushViewController(primaryViewController(), animated: true)
    }
    
    public func goToBookKeeping() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let router = Router(navigationController: navigationController)
        let cordinator = BookKeepingCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }
    
    private func dismiss() {
        dismissModal()
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
}
