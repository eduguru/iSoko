//
//  MainTabsViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 31/07/2025.
//

import Foundation
import DesignSystemKit
import UIKit

final class MainTabsViewModel {
    var showsCenterButton: Bool = false
    var tabBarViewModel: CustomTabBarViewModel?
    
    private func appTabs() -> [TabBarItemModel] {
        return [
            // Market Tab - New icon with house and filled when selected
            TabBarItemModel(
                icon: UIImage(systemName: "house")!, // House icon for normal state
                selectedIcon: UIImage(systemName: "house.fill"), // House icon filled for selected state
                title: "Market",
                color: .app(.primary),
                badgeCount: 0,
                showBadge: false,
                showTitleOnlyWhenSelected: true // Title only shows when selected
            ),
            
            // Business Tab
            TabBarItemModel(
                icon: .businessTabIcon,
                title: "Business",
                color: .app(.primary),
                showTitleOnlyWhenSelected: true // Title only shows when selected
            ),
            
            // Insight Tab
            TabBarItemModel(
                icon: .insightsTabIcon,
                title: "Insight",
                color: .app(.primary),
                badgeCount: 0,
                showBadge: false,
                showTitleOnlyWhenSelected: true // Title only shows when selected
            ),
            
            // Services Tab
            TabBarItemModel(
                icon: .servicesTabIcon,
                title: "Services",
                color: .app(.primary),
                showTitleOnlyWhenSelected: true // Title only shows when selected
            ),
            
            // Account Tab
            TabBarItemModel(
                icon: .accountTabIcon,
                title: "Account",
                color: .app(.primary),
                showTitleOnlyWhenSelected: true // Title only shows when selected
            )
        ]
    }

    init() {
        self.tabBarViewModel = CustomTabBarViewModel(tabs: appTabs())
        bindToTabBarEvents()
    }

    private func bindToTabBarEvents() {
        guard let tabBarViewModel = tabBarViewModel else { return }
        // Optional: react to selection
        tabBarViewModel.onTabSelected = { index in
            print("Tab selected at index \(index)")
            // Add logic if needed to respond to tab selection.
        }

        // Optional: respond to center action
        tabBarViewModel.onCenterAction = {
            print("Center button tapped")
        }
    }

    // MARK: - Badge Logic
    func updateBadge(for index: Int, to count: Int) {
        guard let tabBarViewModel = tabBarViewModel else { return }
        tabBarViewModel.updateBadge(count: count, at: index)
    }

    func incrementBadge(for index: Int) {
        guard let tabBarViewModel = tabBarViewModel else { return }
        tabBarViewModel.incrementBadge(at: index)
    }

    func clearBadge(for index: Int) {
        guard let tabBarViewModel = tabBarViewModel else { return }
        tabBarViewModel.clearBadge(at: index)
    }

    // MARK: - Tab Selection

    func selectTab(at index: Int) {
        guard let tabBarViewModel = tabBarViewModel else { return }
        tabBarViewModel.selectedIndex = index
    }

    var selectedIndex: Int {
        guard let tabBarViewModel = tabBarViewModel else { return 0 }
        return tabBarViewModel.selectedIndex
    }
}
