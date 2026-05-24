//
//  InsightsCoordinator.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class InsightsCoordinator: BaseCoordinator {
    
    func primaryViewController() -> InsightsViewController {
        let model = InsightsViewModel()
        model.goToNewsDetails = goToNewsDetails
        model.goToAssociationNewsDetails = goToNewsDetails
        
        let controller = InsightsViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    private func goToNewsDetails(_ item: DirectusNewsItem) {
        let viewModel = NewsDetailsViewModel(item.toDomain())
        
        let vc = NewsDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    // MARK: - News Details
    private func goToNewsDetails(_ item: AssociationNewsItem) {
        let viewModel = NewsDetailsViewModel(item.toDomain())
        let vc = NewsDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }
    
    public override func start() {
        router.setRoot(primaryViewController())
    }
    
    
    private func dismiss() {
        dismissModal()
    }
}
