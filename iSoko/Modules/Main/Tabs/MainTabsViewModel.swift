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
    
    private func appTabs() -> [TabBarItemModel] { // private static var appTabs = CustomTabBarViewModel.defaultTabs()
        return [
            TabBarItemModel(icon: .marketTabIcon, title: "Market", color: .app(.primary), badgeCount: 0, showBadge: false),
            TabBarItemModel(icon: .businessTabIcon, title: "Business", color: .app(.primary)),
            TabBarItemModel(icon: .insightsTabIcon, title: "Insight", color: .app(.primary), badgeCount: 0, showBadge: false),
            TabBarItemModel(icon: .servicesTabIcon, title: "Services", color: .app(.primary)),
            TabBarItemModel(icon: .accountTabIcon, title: "Account", color: .app(.primary))
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
