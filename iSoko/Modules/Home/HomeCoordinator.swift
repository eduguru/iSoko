//
//  HomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UIKit

class HomeCoordinator: BaseCoordinator {
    
    override func start() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        
        // Use router to set root
        router.setRoot(homeVC, animated: true)
    }

    func startModal() {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        router.setRoot(homeVC, animated: true)
        
        // Example: Present modal flow after some trigger (simulate with delay here)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let modalCoordinator = ModalCoordinator(parentCoordinator: self)
            modalCoordinator.delegate = self
            self.addChild(modalCoordinator)
            modalCoordinator.start()
        }
    }
}

extension HomeCoordinator: CoordinatorDelegate {
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
