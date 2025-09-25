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
        
        viewModel.gotoSignIn = { [weak self] in
            self?.goToLogin(makeRoot: false)
        }
        
        viewModel.gotoSignUp = goToSignup
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        router.setRoot(vc, animated: true)
    }
    
    public func goToLogin(makeRoot: Bool = false) {
        let viewModel = LoginViewModel()
        viewModel.gotoConfirm = goToMainTabs
        
        let vc = LoginViewController()
        vc.viewModel = viewModel

        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.navigationControllerInstance?.navigationBar.isHidden = false

        if makeRoot {
            vc.makeRoot = makeRoot
            router.setRoot(vc, animated: true)
        } else {
            router.push(vc, animated: true)
        }
    }

    
    private func goToSignup() {
        let viewModel = SignupViewModel()
        viewModel.confirmSelection = { [weak self] selection in
            //self?.router.pop(animated: true)
            self?.goToCompleteProfile(selection)
        }
        
        let vc = SignupViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func goToCompleteProfile(_ selectedType: CommonIdNameModel) {
        let viewModel = BasicProfileDataViewModel()
        viewModel.gotoConfirm = goToConfirmProfile
        
        viewModel.gotoSelectGender = gotoSelectGender
        viewModel.gotoSelectAgeRange = gotoSelectAgeRange
        viewModel.gotoSelectRole = gotoSelectRole
        viewModel.gotoSelectLocation = gotoSelectLocation
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToConfirmProfile() {
        let viewModel = BasicProfileSecurityViewModel()
        viewModel.gotoVerify = goToOtpVerification
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToPrivacyPolicy() {
        
    }
    
    private func goToTermsAndConditions() {
        
    }
    
    private func goToOtpVerification(_ verificationNumber: String) {
        let viewModel = OTPFormViewModel(verificationNumber: verificationNumber)
        viewModel.gotoConfirm = { [weak self] in
            self?.goToLogin(makeRoot: true)
        }
        
        let vc = OTPFormViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoSelectAgeRange(_ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .ageGroups)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .idName(let model):
                completion(model)
            default:
                completion(nil) // or ignore if .location is not expected here
            }
            
            // Pop the screen
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
    
    private func gotoSelectRole(_ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .userRoles(page: 1, count: 100))
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .idName(let model):
                completion(model)
            default:
                completion(nil) // or ignore if .location is not expected here
            }
            
            // Pop the screen
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
    
    private func gotoSelectGender(options: [CommonIdNameModel], _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .userRoles(page: 1, count: 100), options: options)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .idName(let model):
                completion(model)
            default:
                completion(nil) // or ignore if .location is not expected here
            }
            
            // Pop the screen
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
    
    private func gotoSelectLocation(_ completion: @escaping (LocationModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .locations(page: 1, count: 100))
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .location(let response):
                let model = LocationModel(with: response)
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
    
    private func gotoForgotPassword() {
        let viewModel = ResetPasswordViewModel()
        let vc = ResetPasswordViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
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
