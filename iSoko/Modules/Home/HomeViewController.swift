//
//  HomeViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import UIKit
import DesignSystemKit

class HomeViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        let btn01 = UIButton(type: .custom)
        btn01.setImage(.bellIcon, for: .normal)
        btn01.addTarget(self, action: #selector(didTapButton01), for: .touchUpInside)
        
        let btn02 = UIButton(type: .custom)
        btn02.setImage(.shoppingbagIcon, for: .normal)
        btn02.addTarget(self, action: #selector(didTapButton02), for: .touchUpInside)
        
        let actionButton01 = UIBarButtonItem(customView: btn01)
        let actionButton02 = UIBarButtonItem(customView: btn02)
        
        navigationItem.rightBarButtonItems = [actionButton02, actionButton01]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
    
    @objc func didTapButton01() {
        
    }
    
    @objc func didTapButton02() {
        
    }
}

