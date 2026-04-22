//
//  AddProductImagesViewController.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//



import UIKit
import DesignSystemKit
import UtilsKit

final class AddProductImagesViewController: FormViewController {

    var makeRoot: Bool = false
    private let pickerCoordinator = FilePickerBottomSheetCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Product"
        guard let vm = viewModel as? AddProductImagesViewModel else {
            fatalError("Expected AddProductImagesViewModel")
        }

        vm.pickFile = { [weak self] completion in
            guard let self else { return }

            self.pickerCoordinator.present(
                from: self,
                selectionLimit: 1,
                allowedTypes: [.pdf, .png, .jpeg]
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

    @objc func close() {
        closeAction?()
    }
}
