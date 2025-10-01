//
//  ServicesCoordinator.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class ServicesCoordinator: BaseCoordinator {
    
    func primaryViewController() -> ServicesViewController {
        var model = ServicesViewModel()
        
        let controller = ServicesViewController()
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
