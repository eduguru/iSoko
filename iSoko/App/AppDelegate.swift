//
//  AppDelegate.swift
//  iSoko
//
//  Created by Edwin Weru on 11/07/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        AppBootstrap.setup()
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle the redirect URL after authentication
        if let oauthService = (window?.rootViewController as? AuthCoordinator)?.oauthService {
            oauthService.handleRedirect(url: url)
        }
        return true
    }

    // Handle Universal Links here if needed (for older iOS versions)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity) -> Bool {
        if let url = userActivity.webpageURL, url.host == "api.dev.isoko.africa" {
            print("OAuth Redirect URL: \(url)")
            // Process the URL (OAuth code exchange etc.)
            return true
        }
        return false
    }

}

extension AppDelegate {
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
