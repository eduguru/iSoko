//
//  ProfileInfoViewController.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import UIKit
import DesignSystemKit

class ProfileInfoViewController: FormViewController, CloseableViewController {
    var goToEditAction: (() -> Void)?
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile Info"
        
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        // Configure "Edit" button
        let btn01 = UIButton(type: .system) // ✅ use .system for automatic tint/color handling
        btn01.setTitle("Edit", for: .normal)
        btn01.setTitleColor(.app(.primary), for: .normal) // ✅ set an explicit color (or .label for adaptive)
        btn01.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        btn01.addTarget(self, action: #selector(didTapButton01), for: .touchUpInside)

        // ✅ Make sure the button has a proper frame
        btn01.sizeToFit()

        // Add to navigation bar
        let actionButton01 = UIBarButtonItem(customView: btn01)
        navigationItem.rightBarButtonItem = actionButton01
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
    
    @objc func didTapButton01() {
        goToEditAction?()
    }
    
    @objc func didTapButton02() {
        
    }
}


