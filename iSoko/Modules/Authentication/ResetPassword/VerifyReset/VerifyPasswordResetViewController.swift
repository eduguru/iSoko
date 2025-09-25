//
//  VerifyPasswordResetViewController.swift
//  
//
//  Created by Edwin Weru on 25/09/2025.
//

import UIKit
import DesignSystemKit

class VerifyPasswordResetViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

