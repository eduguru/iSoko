//
//  SceneDelegate.swift
//  iSoko
//
//  Created by Edwin Weru on 11/07/2025.
//

import UIKit
import StorageKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    
    let certificateService = NetworkEnvironment.shared.certificateService
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //        guard let windowScene = (scene as? UIWindowScene) else { return }
        //
        //        let window = UIWindow(windowScene: windowScene)
        //        window.rootViewController = ViewController()
        //        self.window = window
        //        window.makeKeyAndVisible()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        getToken()
        
        // Initialize AppCoordinator with the window
        appCoordinator = AppCoordinator(window: window)
        
        // Start the coordinator
        appCoordinator?.start()
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
    }

    private func getToken() {
        Task {
            do {
                
                let token = try await certificateService.getToken(
                    grant_type: AppConstants.GrantType.login.rawValue,
                    client_id: ApiEnvironment.clientId,
                    client_secret: ApiEnvironment.clientSecret
                )
                
                print("🔑 accessToken:", token.accessToken)
                AppStorage.accessToken = token.accessToken
            } catch let NetworkError.server(apiError) {
                // ❌ API returned error body
                print("accessToken API error:", apiError.message ?? "")
            } catch {
                // ❌ Networking/decoding
                print("accessToken Unexpected error:", error)
            }
        }
    }
    
}
