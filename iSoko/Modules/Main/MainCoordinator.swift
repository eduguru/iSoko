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

    // Optional modal flows from main tabs
    func startModal() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"

        // Replace stack if needed
        router.setRoot(homeVC, animated: true)

        // Example: Present modal flow after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            let modalCoordinator = ModalCoordinator(parentCoordinator: self)
            modalCoordinator.delegate = self
            self.addChild(modalCoordinator)
            modalCoordinator.start()
        }
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
