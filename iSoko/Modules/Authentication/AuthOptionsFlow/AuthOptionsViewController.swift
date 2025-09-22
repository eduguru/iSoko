//
//  AuthOptionsViewController.swift
//  
//
//  Created by Edwin Weru on 21/09/2025.
//

import UIKit
import DesignSystemKit

class AuthOptionsViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyCloseButtonStyling(action: #selector(close), image: "close")
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

