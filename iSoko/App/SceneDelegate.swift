//
//  SceneDelegate.swift
//  iSoko
//
//  Created by Edwin Weru on 11/07/2025.
//

import UIKit
import StorageKit
import GoogleSignIn

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    private let tokenProvider = AppTokenProvider()
    private let certificateService = NetworkEnvironment.shared.certificateService

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        AppBootstrap.setup()

        window.rootViewController = SplashScreenViewController()
        window.makeKeyAndVisible()

        Task {
            await bootstrap(window: window)
        }
    }

    // MARK: - Bootstrap

    private func bootstrap(window: UIWindow) async {
        print("🚀 Bootstrapping app")

        // 1️⃣ Guest token is REQUIRED
        do {
            let guestToken = try await fetchGuestToken()
            tokenProvider.saveGuestToken(guestToken)
            RuntimeSession.authState = .guest
            print("✅ Guest token ready")
        } catch {
            print("❌ Guest token failed — app cannot proceed")
            return
        }

        // 2️⃣ OAuth token is OPTIONAL
        if AppStorage.hasLoggedIn ?? false {
            await attemptOAuthRestore()
        }

        // 3️⃣ Launch app regardless
        await MainActor.run {
            startApp(window: window)
        }
    }

    // MARK: - OAuth Restore

    private func attemptOAuthRestore() async {
        do {
            let token = try await tokenProvider.refreshOAuthToken()
            RuntimeSession.authState = .authenticated
            print("✅ OAuth restored:", token.accessToken.prefix(6))
        } catch {
            print("⚠️ OAuth restore failed — downgraded to guest")
            RuntimeSession.authState = .guest
            AppStorage.hasLoggedIn = false
        }
    }

    // MARK: - App start

    @MainActor
    private func startApp(window: UIWindow) {
        let coordinator = AppCoordinator(window: window)
        self.appCoordinator = coordinator
        coordinator.start()
    }

    // MARK: - Guest token

    private func fetchGuestToken() async throws -> TokenResponse {
        let token = try await certificateService.getToken(
            grant_type: AppConstants.GrantType.login.rawValue,
            client_id: ApiEnvironment.clientId,
            client_secret: ApiEnvironment.clientSecret
        )

        return TokenResponse(
            accessToken: token.accessToken,
            tokenType: token.tokenType ?? "",
            expiresIn: token.expiresIn,
            scope: token.scope ?? "",
            refreshToken: token.refreshToken
        )
    }
}
