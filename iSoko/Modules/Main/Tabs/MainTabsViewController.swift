//
//  MainTabsViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 31/07/2025.
//

import UIKit
import DesignSystemKit
import RouterKit

@MainActor
final class MainTabsViewController: UITabBarController, CustomTabBarDelegate {

    private var customTabBar: CustomTabBar!
    public var viewModel: MainTabsViewModel?
    // private let tabBarViewModel = CustomTabBarViewModel(tabs: CustomTabBarViewModel.defaultTabs())
    
    // 👇 Initialized once and reused across setup/binding
    private var tabBarViewModel: CustomTabBarViewModel? {
        viewModel?.tabBarViewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()

        Task {
            await setupCustomTabBar()
        }

        bindViewModel()
    }

    private func setupViewControllers() {
        // These should correspond to the number/order of your tab items
        let vc1 = BaseNavigationController(rootViewController: HomeCoordinator().primaryViewController())
        let vc2 = BaseNavigationController(rootViewController: BusinessCoordinator().primaryViewController())
        let vc3 = BaseNavigationController(rootViewController: InsightsCoordinator().primaryViewController())
        let vc4 = BaseNavigationController(rootViewController: ServicesCoordinator().primaryViewController())
        let vc5 = BaseNavigationController(rootViewController: MoreCoordinator().primaryViewController())

        viewControllers = [vc1, vc2, vc3, vc4, vc5]
    }

    private func bindViewModel() {
        guard let tabBarViewModel = tabBarViewModel else { return }
        // Handle badge update forwarding from VM
        tabBarViewModel.onBadgeUpdate = { [weak self] index, count in
            guard let self else { return }
            customTabBar.setBadge(count, at: index)
        }

        // Example badge update (simulate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tabBarViewModel?.updateBadge(count: 4, at: 2)
        }

        // Optional: bind tab selection callback
        tabBarViewModel.onTabSelected = { [weak self] index in
            self?.selectedIndex = index
        }
    }

    private func setupCustomTabBar() async {
        guard let tabBarViewModel = tabBarViewModel else { return }
        tabBar.isHidden = true

        customTabBar = await CustomTabBarLayoutHelper.attachCustomTabBar(
            to: view,
            in: self,
            tabBarViewModel: tabBarViewModel,
            showsCenterButton: viewModel?.showsCenterButton ?? false
        )
    }

    // MARK: - CustomTabBarDelegate
    func didSelectTab(at index: Int) {
        selectedIndex = index
        customTabBar.selectedIndex = index
    }

    func didTapCenterButton() {
        let modal = UIViewController()
        modal.view.backgroundColor = .systemYellow
        modal.title = "Center Action"
        present(modal, animated: true)
    }
}
