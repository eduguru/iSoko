//
//  ModalCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 29/07/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class ModalCoordinator: BaseCoordinator {
    
    public override func start() { }
    
    public func goToCountrySelection(completion: @escaping (Country) -> Void) {
        let model = CountryPickerViewModel()
        model.confirmSelection = { [weak self] country in
            completion(country)
            self?.router.pop()
        }
        
        let vc = CountryPickerViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
//        vc.onRowSelected = model.onRowSelected
//        model.redrawSection = vc.redrawSection
        
        router.push(vc)
    }
    
    func presentModal() {
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
