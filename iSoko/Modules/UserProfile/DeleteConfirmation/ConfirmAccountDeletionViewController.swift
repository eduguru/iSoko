//
//  ConfirmAccountDeletionViewController.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import UIKit
import DesignSystemKit

class ConfirmAccountDeletionViewController: FormViewController, CloseableViewController {
    
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
    
    deinit { }
}

