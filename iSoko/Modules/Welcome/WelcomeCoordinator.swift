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
import StorageKit

class WelcomeCoordinator: BaseCoordinator {
    
    override func start() {
        
        if (AppStorage.hasSelectedRegion ?? false) && (AppStorage.hasSelectedLanguage ?? false) {
            showWalkthrough()
        } else {
            gotoSelectLanguage() // showCountryLanguagePreference()
        }
    }
    
    private func showCountryLanguagePreference() {
        let viewModel = CountryLanguagePreferenceViewModel()
        viewModel.gotoSelectCountry = gotoSelectCountry
        viewModel.gotoSelectLanguage = gotoSelectLanguage
        
        viewModel.gotoConfirm = { [ weak self ] in
            AppStorage.hasSelectedRegion = true
            self?.showWalkthrough()
        }
        
        let viewController = CountryLanguagePreferenceViewController()
        viewController.viewModel = viewModel
        
        router.setRoot(viewController, animated: true)
    }
    
    private func showWalkthrough() {
        if AppStorage.hasViewedWalkthrough ?? false {
            showLoginFlow()
            return
        }
        
        let pages = [
            OnboardingModel(
                title: "onboarding.page1.title".localized,
                description: "onboarding.page1.description".localized,
                media: "onboarding01"
            ),
            OnboardingModel(
                title: "onboarding.page2.title".localized,
                description: "onboarding.page2.description".localized,
                media: "onboarding02"
            ),
            OnboardingModel(
                title: "onboarding.page3.title".localized,
                description: "onboarding.page3.description".localized,
                media: "onboarding03"
            ),
            OnboardingModel(
                title: "onboarding.page4.title".localized,
                description: "onboarding.page4.description".localized,
                media: "onboarding04"
            )
        ]
        
        let buttonStyle: ButtonLayoutStyle = ButtonLayoutStyle(
            primaryColor: .app(.primary),
            secondaryColor: .app(.secondary),
            configuration: .inlineBottom
        )
        
        let viewModel = OnboardingViewModel(pages, layoutStyle: buttonStyle)
        viewModel.nextButtonTitle = "common.next".localized
        viewModel.getStartedButtonTitle = "common.get_started".localized
        viewModel.skipButtonTitle = "common.skip".localized
        
        let viewController = OnboardingController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        
        viewModel.nextButtonTapped = { [ weak self ] in
            AppStorage.hasViewedWalkthrough = true
            self?.showLoginFlow()
        }
        
        viewModel.didSkipButtonTapped = { [ weak self ] in
            AppStorage.hasViewedWalkthrough = true
            self?.showLoginFlow()
        }
        
        // Set walkthrough as root and hide nav bar
        router.setRoot(viewController, animated: false)
        // Hide nav bar
        router.navigationControllerInstance?.setNavigationBarHidden(true, animated: false)
        
        if let nav = router.navigationControllerInstance {
            print("Nav stack: \(nav.viewControllers)")
            print("Is nav bar hidden? \(nav.isNavigationBarHidden)")
        }
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
        coordinator.goToCountrySelection { [weak self] result in
            completion(result)
            self?.router.pop()
        }
    }
    
    private func gotoSelectLanguage(completion: @escaping (Language) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToLanguageSelection{ [weak self] result in
            completion(result)
            self?.router.pop()
        }
    }
    
    //MARK: - we use this if we want transitional screens -
    private func gotoSelectLanguage() {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToLanguageSelection { [weak self] result in
            
            AppStorage.selectedLanguage = result.name
            LocalizationManager.shared.setLanguage(result.code)
            
            AppStorage.hasSelectedLanguage = true
            self?.gotoSelectRegion()
        }
    }
    
    private func gotoSelectRegion() {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToCountrySelection { [weak self] result in
            AppStorage.selectedRegion = result.name
            AppStorage.selectedRegionCode = result.id.lowercased()
            AppStorage.hasSelectedRegion = true
            self?.showWalkthrough()
        }
    }
    //MARK: - we use the above if we want transitional screens -
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
