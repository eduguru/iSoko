//
//  WelcomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import WalkthroughKit
import UIKit
import UtilsKit

class WelcomeCoordinator: BaseCoordinator {
    
    override func start() {
        showCountryLanguagePreference()
    }
    
    private func showCountryLanguagePreference() {
        let viewModel = CountryLanguagePreferenceViewModel()
        viewModel.gotoSelectCountry = gotoSelectCountry
        viewModel.gotoSelectLanguage = gotoSelectLanguage
        
        viewModel.gotoConfirm = { [ weak self ] in
            self?.showWalkthrough()
        }
        
        let viewController = CountryLanguagePreferenceViewController()
        viewController.viewModel = viewModel
        
        router.setRoot(viewController, animated: true)
    }

    private func showWalkthrough() {
        let pages = [
            OnboardingModel(title: "Welcome", description: "Discover features.", media: "onboarding01"),
            OnboardingModel(title: "Secure", description: "Data stays safe.", media: "onboarding02"),
            OnboardingModel(title: "Simple", description: "Get started in seconds.", media: "onboarding03")
        ]
        
        let buttonStyle: ButtonLayoutStyle = ButtonLayoutStyle(
            primaryColor: .app(.primary),
            secondaryColor: .app(.secondary),
            configuration: .inlineBottom
        )
        
        let viewModel = OnboardingViewModel(pages, layoutStyle: buttonStyle)
        let viewController = OnboardingController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        
        viewModel.nextButtonTapped = { [ weak self ] in
            self?.showLoginFlow()
        }

        viewModel.didSkipButtonTapped = { [ weak self ] in
            self?.showLoginFlow()
        }

        // Set walkthrough as root and hide nav bar
        router.setRoot(viewController, animated: false)
    }
    
    private func showLoginFlow() {
        let coordinator = AuthCoordinator(router: router)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }

    private func gotoSelectCountry(completion: @escaping (Country) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToCountrySelection { [weak self] country in
            completion(country)
        }
    }
    
    private func gotoSelectLanguage() {
        
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

extension WelcomeCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)

        if coordinator is WelcomeCoordinator {
            showLoginFlow()
        }
    }
    
    func coordinatorDidPresentModal(_ coordinator: Coordinator) {
        print("Modal coordinator presented")
    }
    
    func coordinatorDidDismissModal(_ coordinator: Coordinator) {
        print("Modal coordinator dismissed")
        removeChild(coordinator)
    }
}
