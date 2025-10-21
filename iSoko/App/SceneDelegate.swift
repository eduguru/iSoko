//
//  SceneDelegate.swift
//  iSoko
//
//  Created by Edwin Weru on 11/07/2025.
//

import UIKit
import StorageKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    
    let certificateService = NetworkEnvironment.shared.certificateService
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // ✅ Show splash screen immediately
        let splashVC = SplashScreenViewController()
        window.rootViewController = splashVC
        window.makeKeyAndVisible()

        // ✅ Start async task in background
        Task {
            let success = await fetchToken()

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                if success {
                    // ✅ Now start the app coordinator
                    self.appCoordinator = AppCoordinator(window: window)
                    self.appCoordinator?.start()
                } else {
                    // Optional: Show error or retry
                    print("❌ Failed to fetch token. Consider showing retry UI.")
                }
            }
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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        print("📥 Received OAuth redirect: \(url)")

        if url.scheme == "weru.isoko.app", url.host == "auth" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                print("🔐 Authorization Code from deep link: \(code)")

                // 👉 You can now exchange the code for tokens
            }
        }
        
        if GIDSignIn.sharedInstance.handle(url) {
            return
        }
    }

    private func fetchToken() async -> Bool {
        do {
            let token = try await certificateService.getToken(
                grant_type: AppConstants.GrantType.login.rawValue,
                client_id: ApiEnvironment.clientId,
                client_secret: ApiEnvironment.clientSecret
            )
            
            print("🔑 accessToken:", token.accessToken)
            AppStorage.accessToken = token.accessToken
            
            return true
        } catch let NetworkError.server(apiError) {
            print("accessToken API error:", apiError.message ?? "")
        } catch {
            print("accessToken Unexpected error:", error)
        }
        return false
    }
    
}
