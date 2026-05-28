//
//  ProfileInfoViewController.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import UIKit
import DesignSystemKit
import UtilsKit

class ProfileInfoViewController: FormViewController, CloseableViewController {
    var goToEditAction: (() -> Void)?
    var makeRoot: Bool = false
    
    private let pickerCoordinator = FilePickerBottomSheetCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile Info"
        
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        
        let btn01 = UIButton(type: .system) //use .system for automatic tint/color handling
        btn01.setTitle("Edit", for: .normal)
        btn01.setTitleColor(.app(.primary), for: .normal) //set an explicit color (or .label for adaptive)
        btn01.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        btn01.addTarget(self, action: #selector(didTapButton01), for: .touchUpInside)

        btn01.sizeToFit()

        
        let actionButton01 = UIBarButtonItem(customView: btn01)
        navigationItem.rightBarButtonItem = actionButton01
        
        guard let vm = viewModel as? ProfileInfoViewModel else {
            fatalError("Expected ProfileInfoViewModel")
        }

        vm.pickFile = { [weak self] completion in
            guard let self else { return }

            self.pickerCoordinator.present(
                from: self,
                selectionLimit: 1,
                allowedTypes: [.png, .jpeg]
            ) { pickedFile in
                
                completion(pickedFile)
            }
        }
        
        
        vm.onPreviewImage = { [weak self] file in
//            guard let data = file.fileData,
//                  let image = UIImage(data: data) else { return }
//
//            let vc = ImagePreviewViewController(image: image)
//            self?.present(vc, animated: true)
        }
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
