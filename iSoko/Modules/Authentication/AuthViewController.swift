//
//  AuthViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import UIKit
import DesignSystemKit

class AuthViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction()
    }
    
    deinit {
        closeAction()
    }
}



import UIKit
import GoogleSignIn

class SigninGoogleTry: UIViewController {
    private var signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add button action
        signInButton.addAction(UIAction(handler: { [weak self] _ in
            self?.googleSignIn()
        }), for: .touchUpInside)
        view.addSubview(signInButton)
        
        // add AutoLayout for the button
        // here we just set the button to the center of the view
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func googleSignIn() {
        // here for simplicity I used completion handler
        // feel free to use async function instead
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error {
                // you can add error handling
                print("Error", error)
                return
            }
            
            // you can add anything with user data if you like
            // here I save user name for HomeViewController
            guard let name = result?.user.profile?.name else {
                // you can add error handling
                print("Invalid user profile")
                return
            }
            
            self?.navigateToHomeViewController(with: name)
        }
    }
    
    private func navigateToHomeViewController(with name: String) {
        // here you can create a HomeViewController and display user name
        // then just redirect to HomeViewController if needed
    }
}
