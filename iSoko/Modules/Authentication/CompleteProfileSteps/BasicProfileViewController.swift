//
//  BasicProfileViewController.swift
//  
//
//  Created by Edwin Weru on 22/09/2025.
//

import UIKit
import DesignSystemKit

class BasicProfileViewController: FormViewController, CloseableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // title = "Complete Your Profile"
        applyCloseButtonStyling(action: #selector(close), image: "backArrow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
}

