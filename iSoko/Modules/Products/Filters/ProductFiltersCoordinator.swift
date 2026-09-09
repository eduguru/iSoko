//
//  ProductFiltersCoordinator.swift
//  
//
//  Created by Edwin Weru on 09/09/2026.
//

import RouterKit

final class ProductFiltersCoordinator: BaseCoordinator {

    private let currentFilters: ProductFilters
    var onFiltersConfirmed: ((ProductFilters) -> Void)?

    init(router: Router, currentFilters: ProductFilters) {
        self.currentFilters = currentFilters
        super.init(router: router)
    }

    override func start() {
        showFilters()
    }

    private func showFilters() {
        let vm = ProductFiltersViewModel(currentFilters: currentFilters)
        vm.onFiltersConfirmed = { [weak self] filters in
            self?.onFiltersConfirmed?(filters)
        }
        vm.onDismiss = { [weak self] in
            self?.router.dismiss(animated: true)
            self?.parentCoordinator?.removeChild(self!)
        }
        vm.goToFilterPicker = { [weak self] option, completion in
            self?.goToFilterPicker(option: option, completion: completion)
        }

        let vc = ProductFiltersViewController()
        vc.viewModel = vm
        vc.closeAction = { [weak self] in
            self?.router.dismiss(animated: true)
            self?.parentCoordinator?.removeChild(self!)
        }

        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        router.present(nav, animated: true)

        // Update router to point at the filters nav so pushes go inside it
        self.router = Router(navigationController: nav)
    }

    private func goToFilterPicker(option: FilterPickerOption, completion: @escaping (CommonIdNameModel?) -> Void) {
        let vm = FilterOptionPickerViewModel(option: option)
        vm.onSelected = { [weak self] value in
            completion(value)
            self?.router.pop(animated: true)
        }

        let vc = FilterOptionPickerViewController()
        vc.viewModel = vm
        vc.closeAction = { [weak self] in self?.router.pop(animated: true) }

        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
}
