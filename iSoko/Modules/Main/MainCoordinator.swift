//
//  MainCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UIKit

class MainCoordinator: BaseCoordinator {

    override func start() {
        // 1. Create the main tabs VC
        let vc = MainTabsViewController()
        let viewModel = MainTabsViewModel()
        vc.viewModel = viewModel

        // 2. Set as root of the router’s navigation controller
        // This replaces the current stack without creating a new nav controller
        router.replaceRoot(with: vc)
    }
}

extension MainCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }

    func coordinatorDidPresentModal(_ coordinator: Coordinator) {
        print("Modal coordinator presented")
    }

    func coordinatorDidDismissModal(_ coordinator: Coordinator) {
        print("Modal coordinator dismissed")
        removeChild(coordinator)
    }
}
