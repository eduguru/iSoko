//
//  AuthCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import AuthenticationServices
import UtilsKit
import StorageKit

class AuthCoordinator: BaseCoordinator {
    private var authSession: ASWebAuthenticationSession?

    override func start() {
        if AppStorage.hasShownInitialLoginOptions ?? false {
            goToMainTabs()
        } else {
            goToAuthOptions()
        }
    }
    
    private func goToAuthOptions() {
        let viewModel = AuthViewModel()
        let vc = AuthViewController()
        vc.viewModel = viewModel
        
        viewModel.gotoSignIn = { [weak self] in
            self?.startOAuthFlow()
            // self?.goToLogin(makeRoot: false)
        }
        
        viewModel.gotoSignUp = goToSignupOptions
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        AppStorage.hasShownInitialLoginOptions = true
        router.setRoot(vc, animated: true)
    }

    private func startOAuthFlow() {
        OAuthService().startOAuthFlow { result in
            switch result {
            case .success(let code):
                print("✅ Got code: \(code)")
            case .failure(let error):
                print("❌ OAuth flow failed: \(error)")
            }
        }
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
    
    private func goToSignupOptions() {
        let viewModel = SignUpOptionsViewModel()
        viewModel.showCountryPicker = gotoSelectCountry
        
        viewModel.goToOtp = goToOtpVerification
        viewModel.goToCompleteProfile = goToCompleteIndividualProfile
        
        let vc = SignUpOptionsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
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
    
    private func goToSignup() {
        let viewModel = SignupViewModel()
        viewModel.confirmSelection = { [weak self] selection, type in
            //self?.router.pop(animated: true)
            self?.goToCompleteProfile(selection, registrationType: type)
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
    
    private func goToCompleteIndividualProfile() {
        let viewModel = BasicProfileDataViewModel(registrationType: .individual)
        viewModel.gotoConfirm = goToConfirmProfile
        
        viewModel.gotoSelectGender = gotoSelectGender
        viewModel.gotoSelectAgeRange = gotoSelectAgeRange
        viewModel.gotoSelectRole = gotoSelectRole
        viewModel.gotoSelectLocation = gotoSelectLocation
        viewModel.gotoSelectOrgType = gotoSelectOrgType
        viewModel.gotoSelectOrgSize = gotoSelectOrgSize
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToCompleteProfile(_ selectedType: CommonIdNameModel, registrationType: RegistrationType) {
        let viewModel = BasicProfileDataViewModel(registrationType: registrationType)
        viewModel.gotoConfirm = goToConfirmProfile
        
        viewModel.gotoSelectGender = gotoSelectGender
        viewModel.gotoSelectAgeRange = gotoSelectAgeRange
        viewModel.gotoSelectRole = gotoSelectRole
        viewModel.gotoSelectLocation = gotoSelectLocation
        viewModel.gotoSelectOrgType = gotoSelectOrgType
        viewModel.gotoSelectOrgSize = gotoSelectOrgSize
        
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
        viewModel.goToLogin = { [weak self] in
            // self?.goToLogin(makeRoot: true)
            self?.goToMainTabs()
        }
        
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
    
    private func goToOtpVerification(_ type: OTPVerificationType, onSuccess: (() -> Void)? = nil) {
        let viewModel = OTPFormViewModel(type: type)

        viewModel.gotoConfirm = { [weak self] in
            onSuccess?()
        }

        viewModel.onResendCode = {
            print("🔁 Resend requested for \(type.targetValue)")
            // Optionally re-trigger OTP send logic here
        }

        viewModel.onOTPComplete = { otp in
            print("✅ OTP entered: \(otp)")
            // Add validation or API logic here if needed
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
    
    private func gotoSelectOrgType(_ completion: @escaping (OrganisationTypeModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .organisationType(page: 1, count: 100))
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .organisationType(let model):
                completion(OrganisationTypeModel(with: model))
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
    
    private func gotoSelectOrgSize(_ completion: @escaping (OrganisationSizeModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .organisationSize(page: 1, count: 100))
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .organisationSize(let model):
                completion(OrganisationSizeModel(with: model))
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
        viewModel.confirmSelection = goToResetPasswordOtpVerification
        
        let vc = ResetPasswordViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func gotoVerifyForgotPassword(_ value: String) {
        let viewModel = VerifyPasswordResetViewModel()
        viewModel.confirmSelection = { [weak self] _, _ in
            self?.goToResetPasswordSuccess()
        }
        
        let vc = VerifyPasswordResetViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func goToResetPasswordOtpVerification(_ verification: OTPVerificationType) {
        let viewModel = OTPFormViewModel(type: verification)
        viewModel.gotoConfirm = { [weak self] in
            self?.gotoVerifyForgotPassword(verification.targetValue)
        }
        
        viewModel.onResendCode = {
            print("🔁 Resend requested for \(verification.targetValue)")
        }
        
        let vc = OTPFormViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToResetPasswordSuccess() {
        let viewModel = ResetPasswordSuccessViewModel()
        viewModel.gotoSignIn = { [weak self] in
            self?.goToLogin(makeRoot: true)
        }
        
        let vc = ResetPasswordSuccessViewController()
        vc.viewModel = viewModel
        vc.makeRoot = true
        
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        // router.setRoot(vc, animated: true)
    }
    
    private func gotoReturningUser(_ value: String) {
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

extension AuthCoordinator: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return router.navigationControllerInstance?.view.window ?? ASPresentationAnchor()
    }
}
