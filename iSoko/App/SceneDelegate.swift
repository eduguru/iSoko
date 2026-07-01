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

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        AppBootstrap.setup()
        UIFont.overrideFonts()

        window.rootViewController = SplashScreenViewController()
        window.makeKeyAndVisible()

        Task {
            await bootstrap(window: window)
        }
    }

    // MARK: - Bootstrap

    private func bootstrap(window: UIWindow) async {
        print("🚀 Bootstrapping app")

        if AppStorage.hasLoggedIn ?? false {
            await attemptOAuthRestore()
        } else {
            RuntimeSession.authState = .guest
        }

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
            print("OAuth restore failed")
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
}
