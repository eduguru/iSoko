//
//  AuthCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit

class AuthCoordinator: BaseCoordinator {

    override func start() {
        goToAuthOptions()
    }
    
    private func goToAuthOptions() {
        let viewModel = AuthViewModel()
        let vc = AuthViewController()
        vc.viewModel = viewModel
        
        viewModel.gotoSignIn = goToLogin
        viewModel.gotoSignUp = goToSignup
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        router.setRoot(vc, animated: true)
    }
    
    private func goToLogin() {
        let viewModel = LoginViewModel()
        let vc = LoginViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }

//        router.navigationControllerInstance?.isNavigationBarHidden = false
        router.navigationControllerInstance?.setNavigationBarHidden(false, animated: false)
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToSignup() {
        let viewModel = SignupViewModel()
        viewModel.confirmSelection = { [weak self] selection in
            //self?.router.pop(animated: true)
            self?.goToCompleteProfile(selection)
        }
        
        let vc = SignupViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func goToCompleteProfile(_ selectedType: CommonIdNameModel) {
        let viewModel = BasicProfileDataViewModel()
        viewModel.gotoConfirm = goToConfirmProfile
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToConfirmProfile() {
        let viewModel = BasicProfileSecurityViewModel()
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToPrivacyPolicy() {
        
    }
    
    private func goToTermsAndConditions() {
        
    }
    
    private func gotoForgotPassword() {
        let viewModel = ResetPasswordViewModel()
        let vc = ResetPasswordViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.setNavigationBarHidden(false, animated: false)
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func gotoReturningUser() {
        let viewModel = ReturningUserViewModel()
        let vc = ReturningUserViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.setNavigationBarHidden(false, animated: false)
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func goToMainTabs() {
        let router = Router(navigationController: navigationController)
        let cordinator = MainCoordinator(router: router)
        addChild(cordinator)
        cordinator.start()
    }
}


extension AuthCoordinator: CoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }
}
