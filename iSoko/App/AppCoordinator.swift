//
//  AppCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UIKit
import UIKit
import StorageKit

@MainActor
class AppCoordinator: BaseCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window

        // Create a BaseNavigationController for the root navigation
        let rootNavController = BaseNavigationController()

        // Create Router with this navigation controller
        let router = Router(navigationController: rootNavController)

        // Call super.init with router to set everything up properly
        super.init(router: router)

        // Set rootViewController on window early
        window.rootViewController = rootNavController
        window.makeKeyAndVisible()
    }

    override func start() {
        showWelcomeFlow()
        observeAuthLogout()
    }
    
    private func showWelcomeFlow() {
        let newNav = BaseNavigationController()
        window.rootViewController = newNav
        window.makeKeyAndVisible()

        let router = Router(navigationController: newNav)
        let cordinator = WelcomeCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }
    
    private func showLoginFlow() {
        let newNav = BaseNavigationController()
        window.rootViewController = newNav
        window.makeKeyAndVisible()

        let router = Router(navigationController: newNav)
        let cordinator = AuthCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }
    
    private func showMainTabsFlow() {
        let newNav = BaseNavigationController()
        window.rootViewController = newNav
        window.makeKeyAndVisible()

        let router = Router(navigationController: newNav)
        let cordinator = HomeCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }

    private func showHomeFlow() {
        // Clean root navigation stack
        router.setRoot(BaseNavigationController(), animated: false)
        
        // Create new router for new nav controller
        guard let newNav = router.navigationControllerInstance else { return }
        let router = Router(navigationController: newNav)
        
        let cordinator = HomeCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }
}

extension AppCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)

        if coordinator is AuthCoordinator {
            showHomeFlow()
        }
    }

    
    //MARK: - for logout listening flow -
    private func observeAuthLogout() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLogoutNotification),
            name: .authTokenExpired,
            object: nil
        )
    }

    @objc private func handleLogoutNotification() {
        Task { @MainActor in
            logoutAndResetApp()
        }
    }
    
    @MainActor
    private func logoutAndResetApp() {
        print("🚪 Global logout")

        // 1️⃣ Clear coordinators
        childCoordinators.removeAll()

        // 2️⃣ Reset root navigation
        let newNav = BaseNavigationController()
        window.rootViewController = newNav
        window.makeKeyAndVisible()

        // 3️⃣ Start Auth flow
        let router = Router(navigationController: newNav)
        let authCoordinator = AuthCoordinator(router: router)
        addChild(authCoordinator)
        authCoordinator.start()
    }

}
