//
//  WelcomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import WalkthroughKit
import UIKit

class WelcomeCoordinator: BaseCoordinator {
    
    override func start() {
        showWalkthrough()
    }
    
    private func showSplashScreen() {
        
    }

    private func showWalkthrough() {
        let pages = [
            OnboardingModel(title: "Welcome", description: "Discover features.", media: "onboarding01"),
            OnboardingModel(title: "Secure", description: "Data stays safe.", media: "onboarding02"),
            OnboardingModel(title: "Simple", description: "Get started in seconds.", media: "onboarding03")
        ]
        
        let viewModel = OnboardingViewModel(pages)
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
