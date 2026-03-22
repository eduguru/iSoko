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
        let model = ServicesViewModel()
        
        model.onTapTradeService = goToTradeServiceDetails
        model.onTapLogisticsService = goToLogisticsServiceDetails
        
        let controller = ServicesViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    public override func start() {
        // router.push(primaryViewController())
        router.setRoot(primaryViewController())
    }
    
    private func goToTradeServiceDetails(service: ServiceProviderResponse) {
        let model = TradeServiceProviderDetailsViewModel(service)
        let controller = TradeServiceProviderDetailsViewController()
        controller.viewModel = model
        controller.closeAction = pop
        router.push(controller)
    }
    
    private func goToLogisticsServiceDetails(service: LogisitcisServiceProviderResponse) {
        let model = LogisticsServiceProviderDetailsViewModel(service)
        let controller = LogisticsServiceProviderDetailsViewController()
        controller.viewModel = model
        controller.closeAction = pop
        router.push(controller)
    }
    
    private func pop() {
        router.pop()
    }
    
    private func dismiss() {
        dismissModal()
    }
}
