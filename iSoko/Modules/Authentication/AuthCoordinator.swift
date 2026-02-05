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
        let viewModel = AuthViewModel()
        let vc = AuthViewController()
        vc.viewModel = viewModel
        
        viewModel.gotoSignIn = { [weak self] verifier in
            self?.authenticate(verifier: verifier)
        }

        viewModel.goToHome = goToMainTabs
        
        viewModel.gotoSignUp = goToSignupOptions
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        AppStorage.hasShownInitialLoginOptions = true
        
        // Use router to set root
        vc.modalPresentationStyle = .fullScreen
        router.present(vc, animated: true)
    }

    
    private func goToAuthOptions() {
        let viewModel = AuthViewModel()
        let vc = AuthViewController()
        vc.viewModel = viewModel
        
        viewModel.gotoSignIn = { [weak self] verifier in
            self?.authenticate(verifier: verifier)
        }
        
        viewModel.goToHome = goToMainTabs
        
        viewModel.gotoSignUp = goToSignupOptions
        viewModel.gotoForgotPassword = gotoForgotPassword
        viewModel.gotoGuestSession = goToMainTabs
        
        AppStorage.hasShownInitialLoginOptions = true
        
        vc.modalPresentationStyle = .fullScreen
        router.setRoot(vc, animated: true)
    }
    
    private func exchangeCodeForToken(verifier: String) {
            oauthService = OAuthService()

            oauthService?.startAuthorization(verifier: verifier) { [weak self] result in
                switch result {
                case .success(let code):
                    self?.oauthService?.exchangeCodeForToken(authorizationCode: code) { tokenResult in
                        switch tokenResult {
                        case .success(let token):
                            // Handle successful token exchange
                            print("Access token:", token.accessToken)
                            
                            // You can now navigate to the main screen or do other tasks
                            self?.goToMainTabs()

                        case .failure(let error):
                            // Handle failure to exchange code for token
                            print("Token error:", error)
                        }
                    }
                case .failure(let error):
                    print("Authorization error:", error)
                }
            }
        }

    private func startOAuth(
        verifier: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        oauthService = OAuthService()

        oauthService?.startAuthorization(verifier: verifier) { result in
            completion(result)
        }
    }
    
    private func exchangeCode(
        _ code: String,
        completion: @escaping (Result<TokenResponse, Error>) -> Void
    ) {
        oauthService?.exchangeCodeForToken(authorizationCode: code) { result in
            completion(result)
        }
    }

    private func fetchUserDetails(
        accessToken: String,
        completion: @escaping (Result<UserDetails, Error>) -> Void
    ) {
        oauthService?.getUserDetails(accessToken: accessToken) { result in
            completion(result)
        }
    }
    
    private func authenticate(verifier: String) {
        startOAuth(verifier: verifier) { [weak self] authResult in
            switch authResult {
            case .success(let code):
                self?.exchangeCode(code) { tokenResult in
                    
                    switch tokenResult {
                    case .success(let token):
                        
                        print("authenticate Access token:", token.accessToken)

                        self?.fetchUserDetails(accessToken: token.accessToken) { userResult in
                            switch userResult {
                            case .success(let user):
                                
                                print("User:", user)
                                AppStorage.userProfile = user
                                self?.goToMainTabs()

                            case .failure(let error):
                                print("User details error:", error)
                            }
                        }

                    case .failure(let error):
                        print("Token exchange error:", error)
                    }
                }

            case .failure(let error):
                print("Authorization error:", error)
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
        
        viewModel.goToOtp = goToOtpVerification
        viewModel.goBack = { [weak self] in
            self?.router.pop(animated: true)
        }
        viewModel.goToCompleteProfile = goToCompleteIndividualProfile
        
        let vc = SignUpOptionsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        // router.navigationControllerInstance?.navigationBar.isHidden = false
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
            self?.goToCompleteProfile(builder: builder, selection, registrationType: type)
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
        let viewModel = BasicProfileDataViewModel(builder: builder, registrationType: .individual)
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
    
    private func goToCompleteProfile(builder: RegistrationBuilder, _ selectedType: CommonIdNameModel, registrationType: RegistrationType) {
        let viewModel = BasicProfileDataViewModel(builder: builder, registrationType: registrationType)
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
    
    private func goToConfirmProfile(builder: RegistrationBuilder) {
        let viewModel = BasicProfileSecurityViewModel(builder: builder, registrationType: .individual)
        viewModel.gotoVerify = goToOtpVerification
        viewModel.goToLogin = { [weak self] in
            let verifier = AppStorage.verifier ?? ""
            self?.authenticate(verifier: verifier)
            // self?.goToMainTabs() // self?.goToLogin(makeRoot: true)
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
        let viewModel = CommonOptionPickerViewModel(option: .userRoles(page: 0, count: 100))
        
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
        let viewModel = CommonOptionPickerViewModel(option: .organisationType(page: 0, count: 100))
        
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
        let viewModel = CommonOptionPickerViewModel(option: .organisationSize(page: 0, count: 100))
        
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
        let viewModel = CommonOptionPickerViewModel(option: .userGender(page: 0, count: 100), options: options)
        
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
    
    private func gotoSelectGender(_ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: .userGender(page: 0, count: 100))
        
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
        let viewModel = CommonOptionPickerViewModel(option: .locations(page: 0, count: 100))
        
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
            
            let router = Router(navigationController: navigationController)
            let cordinator = MainCoordinator(router: router)
            addChild(cordinator)
            cordinator.start()
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
