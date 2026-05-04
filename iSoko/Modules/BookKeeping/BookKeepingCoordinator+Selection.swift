//
//  BookKeepingCoordinator+Selection.swift
//  
//
//  Created by Edwin Weru on 30/04/2026.
//
import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public extension BookKeepingCoordinator {
    func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToCommonSelection(type, staticOptions) { [weak self] result in
            completion(result)
        }
    }
    
    func goToProductSelection(_ type: CommonUtilityOption, _ completion: @escaping (StockResponse?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .products(let model):
                completion(model)
            default:
                completion(nil)
            }
            
            self?.router.pop(animated: true)
        }
        
        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    func gotoSelectSystemCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .countries(let response):
                let model = response
                completion(model)
            default:
                completion(nil)
            }
            
            self?.router.pop(animated: true)
        }
        
        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    func gotoSelectCountry(completion: @escaping (Country) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToCountrySelection { [weak self] result in
            completion(result)
            self?.router.pop()
        }
    }
    
    func gotoSelectDate(config: DatePickerConfig,completion: @escaping (Date?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToAppleStyleCalendar(config: config) { [weak self] result in
            completion(result)
        }
    }
    
    public func goToSelectExpenseCategory() {
        goToCommonSelection(CommonUtilityOption.ageGroups, nil) { [weak self]_ in
            
        }
    }
    
}
