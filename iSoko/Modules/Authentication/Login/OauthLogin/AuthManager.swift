//
//  AuthManager.swift
//  Created by Edwin Weru on 09/10/2025.
//

import Foundation
import UIKit
import GoogleSignIn

class AuthManager {
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<String, Error>) -> Void) {
        // Get client ID from Config.plist
        guard let clientID = ConfigManager.value(forKey: "GoogleClientID") else {
            completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Client ID not found in config."
            ])))
            return
        }

        // Create GIDConfiguration with client ID
        let configuration = GIDConfiguration(clientID: clientID)

        // Start the sign-in flow
        GIDSignIn.sharedInstance.configuration = configuration
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let result = signInResult,
                let idToken = result.user.idToken?.tokenString
            else {
                completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to retrieve ID token."
                ])))
                return
            }

            // Optional: print user info
            let profile = result.user.profile
            print("✅ Google Sign-In successful. Name: \(profile?.name ?? "N/A")")

            completion(.success(idToken))
        }
    }
}

enum ConfigManager {
    static func value(forKey key: String) -> String? {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        else {
            return nil
        }

        return plist[key] as? String
    }
}
