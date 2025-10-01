//
//  HomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class HomeCoordinator: BaseCoordinator {
    
    func primaryViewController() -> HomeViewController {
        var model = HomeViewModel()
        
        let controller = HomeViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    public override func start() {
        navigationController?.pushViewController(primaryViewController(), animated: true)
    }
    
    
    public func dismiss() {
        dismissModal()
    }
}


extension HomeCoordinator: CoordinatorDelegate {
    public func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }
    
    public func coordinatorDidPresentModal(_ coordinator: Coordinator) {
        print("Modal coordinator presented")
    }
    
    public func coordinatorDidDismissModal(_ coordinator: Coordinator) {
        print("Modal coordinator dismissed")
        removeChild(coordinator)
    }
}
