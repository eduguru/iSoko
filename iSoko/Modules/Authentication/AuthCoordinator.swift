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
    public var oauthService: OAuthService?
    
    override func start() {
        if AppStorage.hasShownInitialLoginOptions ?? false {
            goToMainTabs()
        } else {
            goToAuthOptions()
        }
    }
    
    public func popLogginFlow() {
        let nav = BaseNavigationController()
        let newRouter = Router(navigationController: nav)
        
        let coordinator = AuthCoordinator(router: newRouter)
        addChild(coordinator)
        coordinator.start()
        
        nav.modalPresentationStyle = .fullScreen
        router.present(nav, animated: true)
    }
    
    private func goToAuthOptions() {
        let viewModel = AuthViewModel()
        let vc = AuthViewController()
        vc.viewModel = viewModel
        
        viewModel.gotoSignIn = { [weak self] verifier in
            Task { await self?.authenticate(verifier: verifier) }
        }
        
        viewModel.gotoSignUp = goToSignupOptions
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        AppStorage.hasShownInitialLoginOptions = true
        
        vc.modalPresentationStyle = .fullScreen
        router.setRoot(vc, animated: true)
    }
    
    // MARK: - Async OAuth Flow
    private func authenticate(verifier: String) async {
        do {
            oauthService = OAuthService.shared
            // Step 1: Get authorization code
            let code = try await oauthService!.startAuthorization(verifier: verifier)
            
            // Step 2: Exchange code for token
            let token = try await oauthService!.exchangeCodeForToken(authorizationCode: code)
            print("✅ Token received: \(token.accessToken)")
            
            // Step 3: Fetch user details
            let user = try await oauthService!.fetchUserAndUpdateStorage()
            print("✅ User logged in: \(user)")
            
            // Navigate to main tabs
            goToMainTabs()
            
        } catch {
            print("❌ OAuth flow failed:", error)
            // Optionally show an error alert to the user
            await MainActor.run {
                // show error UI
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
    
    private func goToSignupOptions(builder: RegistrationBuilder) {
        let viewModel = SignUpOptionsViewModel(builder: builder)
        viewModel.showCountryPicker = gotoSelectCountry
        
        // When continuing, go to OTP and then move on success
        viewModel.goToOtp = { [weak self] builder, type, onSuccess in
            self?.goToSignupOtpVerification(type) {
                onSuccess?() // Forward the success callback
                self?.goToCompleteIndividualProfile(builder: builder)
            }
        }
        
        viewModel.goBack = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        viewModel.goToCompleteProfile = { [weak self] builder in
            self?.goToCompleteIndividualProfile(builder: builder)
        }
        
        let vc = SignUpOptionsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.push(vc, animated: true)
    }
    
    private func goToSignupOtpVerification(_ type: OTPVerificationType, onSuccess: (() -> Void)? = nil) {
        let viewModel = SignupOTPViewModel(type: type)
        
        // OTP verified → trigger success callback
        viewModel.onOTPVerified = {
            onSuccess?() // Report back to caller
        }
        
        viewModel.onResendCode = {
            print("🔄 Resend requested for \(type.targetValue)")
            // Optionally re-trigger OTP send logic here
        }
        
        viewModel.onOTPFailure = { otp in
            print("❌ OTP verification failed for entered OTP: \(otp)")
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
        viewModel.confirmSelection = { [weak self] builder, selection, type in
            //self?.router.pop(animated: true)
            self?.goToCompleteProfile(builder: builder, selection)
        }
        
        let vc = SignupViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        
    }
    
    private func goToCompleteIndividualProfile(builder: RegistrationBuilder) {
        let viewModel = BasicProfileDataViewModel(builder: builder)
        viewModel.gotoConfirm = goToConfirmProfile
        
        viewModel.goToCommonSelectionOptions = goToCommonSelection
        viewModel.gotoSelectLocation = gotoSelectLocation
        viewModel.gotoSelectCountry = gotoSelectCountry
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToCompleteProfile(builder: RegistrationBuilder, _ selectedType: CommonIdNameModel) {
        let viewModel = BasicProfileDataViewModel(builder: builder)
        viewModel.gotoConfirm = goToConfirmProfile
        
        viewModel.goToCommonSelectionOptions = goToCommonSelection
        viewModel.gotoSelectLocation = gotoSelectLocation
        
        let vc = BasicProfileViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToConfirmProfile(builder: RegistrationBuilder) {
        let viewModel = BasicProfileSecurityViewModel(builder: builder, registrationType: .individual)
        viewModel.gotoVerify = goToOtpVerification
        viewModel.goToLogin = { [weak self] in
//            let verifier = AppStorage.verifier ?? ""
//            self?.authenticate(verifier: verifier)
            self?.goToLogin(makeRoot: true)
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
        
        viewModel.onOTPSuccess = { [weak self] in
            onSuccess?()
        }
        
        viewModel.onResendCode = {
            print(" Resend requested for \(type.targetValue)")
            // Optionally re-trigger OTP send logic here
        }
        
        viewModel.onOTPFailure = { otp in
            print("onOTPFailure OTP entered: \(otp)")
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
    
    private func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type, options: staticOptions)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .idName(let model):
                completion(model)
            default:
                completion(nil)
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
    
    private func gotoSelectLocation(_ type: CommonUtilityOption, _ completion: @escaping (LocationModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
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
    
    private func gotoSelectCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
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
    
    private func gotoSelectOrgType(_ type: CommonUtilityOption, _ completion: @escaping (OrganisationTypeModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
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
    
    private func gotoSelectOrgSize(_ type: CommonUtilityOption, _ completion: @escaping (OrganisationSizeModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
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
    
    
    private func gotoForgotPassword() {
        let viewModel = ResetPasswordViewModel()
        viewModel.confirmSelection = goToResetPasswordOtpVerification
        
        let vc = ResetPasswordViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        
    }
    
    private func gotoVerifyForgotPassword(_ value: String) {
        let viewModel = VerifyPasswordResetViewModel()
        viewModel.confirmSelection = { [weak self] _, _ in
            self?.goToResetPasswordSuccess()
        }
        
        let vc = VerifyPasswordResetViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        
    }
    
    private func goToResetPasswordOtpVerification(_ verification: OTPVerificationType) {
        let viewModel = OTPFormViewModel(type: verification)
        viewModel.onOTPSuccess = { [weak self] in
            self?.gotoVerifyForgotPassword(verification.targetValue)
        }
        
        viewModel.onResendCode = {
            print(" Resend requested for \(verification.targetValue)")
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
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        
    }
    
    private func gotoReturningUser(_ value: String) {
        let viewModel = ReturningUserViewModel()
        let vc = ReturningUserViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
        
    }
    
    private func goToMainTabs() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Reuse the current root navigation controller
            let router = Router(navigationController: self.router.navigationControllerInstance)
            
            // 2. Create MainCoordinator using the same nav
            let mainCoordinator = MainCoordinator(router: router)
            
            // 3. Retain coordinator to prevent deinit
            self.addChild(mainCoordinator)
            
            // 4. Start flow
            mainCoordinator.start()
        }
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
