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

        // Bootstrap (region, env, etc.)
        AppBootstrap.setup()

        // Splash immediately
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
        let authToken = AppStorage.oauthToken
        let loggedIn = AppStorage.hasLoggedIn ?? false
        
        do {
            // If we already have a token, try refresh (logged-in or guest)
            if authToken != nil && loggedIn {
                _ = try await tokenProvider.refreshToken()
            } else { // First launch / cold start (guest)
                let success = await fetchGuestToken()
                
                guard success else {
                    print("❌ Failed to obtain initial token")
                    return
                }
            }

            await MainActor.run {
                self.startApp(window: window)
            }

        } catch OAuthError.unauthorized {
            print("🚪 Unauthorized — logging out")

        } catch {
            print("❌ Bootstrap failed:", error)
        }
    }

    private func fetchGuestToken() async -> Bool {
        do {
            let token = try await certificateService.getToken(
                grant_type: AppConstants.GrantType.login.rawValue,
                client_id: ApiEnvironment.clientId,
                client_secret: ApiEnvironment.clientSecret
            )

            AppStorage.guestToken = TokenResponse(
                accessToken: token.accessToken,
                tokenType: token.tokenType ?? "",
                expiresIn: token.expiresIn,
                scope: token.scope ?? "",
                refreshToken: token.refreshToken
            )

            return true

        } catch {
            print("❌ Guest token fetch failed:", error)
            return false
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
