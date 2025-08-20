//
//  MainTabsViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 31/07/2025.
//

import Foundation
import DesignSystemKit

final class MainTabsViewModel {
    var showsCenterButton: Bool = false
    var tabBarViewModel: CustomTabBarViewModel?
    
    private func appTabs() -> [TabBarItemModel] { // private static var appTabs = CustomTabBarViewModel.defaultTabs()
        return [
            TabBarItemModel(iconName: "house.fill", title: "Home", color: .app(.primary), badgeCount: 0, showBadge: false),
            TabBarItemModel(iconName: "magnifyingglass", title: "Search", color: .app(.primary)),
            TabBarItemModel(iconName: "bell.fill", title: "Alerts", color: .app(.primary), badgeCount: 4, showBadge: true),
            TabBarItemModel(iconName: "person.fill", title: "Profile", color: .app(.primary))
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
