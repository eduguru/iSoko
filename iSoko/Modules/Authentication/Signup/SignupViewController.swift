//
//  SignupViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import UIKit
import DesignSystemKit

class SignupViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create an Account"
        // Do any additional setup after loading the view.
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit {
        print("👋 ViewController is being popped or dismissed")
    }
}

