//
//  SignUpOptionsViewController.swift
//  
//
//  Created by Edwin Weru on 07/10/2025.
//

import UIKit
import DesignSystemKit

class SignUpOptionsViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit {
    }
}
