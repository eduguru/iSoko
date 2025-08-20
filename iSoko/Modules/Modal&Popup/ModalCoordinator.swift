//
//  ModalCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 29/07/2025.
//

import RouterKit
import UIKit

class ModalCoordinator: BaseCoordinator {
    
    override func start() {
        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .systemPurple
        modalVC.title = "Modal Flow"
        modalVC.modalPresentationStyle = .fullScreen
        
        presentModal(modalVC)
    }
    
    func dismiss() {
        dismissModal()
    }
}
