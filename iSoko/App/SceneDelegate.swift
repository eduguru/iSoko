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
    var appCoordinator: AppCoordinator?

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
            await bootstrapApp(window: window)
        }
    }

    @MainActor
    private func startApp(window: UIWindow) {
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }

    private func bootstrapApp(window: UIWindow) async {
        let loggedIn = AppStorage.hasLoggedIn ?? false
        print("🚀 Booting app. loggedIn=\(loggedIn)")

        do {
            try await withThrowingTaskGroup(of: Void.self) { group in

                group.addTask {
                    let token = try await self.fetchGuestToken()
                    self.tokenProvider.saveGuestToken(token)
                    print("✅ Guest token saved")
                }

                if loggedIn {
                    group.addTask {
                        let token = try await self.tokenProvider.refreshOAuthToken()
                        print("✅ OAuth token refreshed: \(token.accessToken.prefix(6))...")
                    }
                }

                try await group.waitForAll()
            }

            await MainActor.run {
                self.startApp(window: window)
            }

        } catch OAuthError.unauthorized {
            print("🚪 Unauthorized — logging out")
            AppStorage.hasLoggedIn = false
            // show login screen

        } catch {
            print("❌ Bootstrap failed:", error)
            // show error screen / retry
        }
    }

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
