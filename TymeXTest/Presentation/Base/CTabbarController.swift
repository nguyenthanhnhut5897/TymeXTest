//
//  CTabbarController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/10.
//

import UIKit

class CTabbarController: UITabBarController {
    
    deinit {
        print("deinit \(self)")
    }
    
    var onDidAppear: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension CTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Scroll to top when corresponding view controller was already selected and no other viewcontrollers are pushed
        guard tabBarController.viewControllers?[tabBarController.selectedIndex] == viewController,
              let navigationController = viewController as? UINavigationController, navigationController.viewControllers.count == 1,
              var topViewController = navigationController.viewControllers.first else {
            return true
        }
        
        if let tableView = topViewController.view.subviews.first(where: { $0 is UITableView }) as? UITableView {
            // Can't scroll to top if table has header view so we need to scroll to zero cell and then scroll to visible rect(1,1)
            if tableView.tableHeaderView != nil {
                let didScroll = (tableView.contentOffset.y + ViewUI.StatusBarHeight) != 0
                
                // Scroll to zero cell when content offset > header size
                if (tableView.contentOffset.y + ViewUI.StatusBarHeight) > (tableView.tableHeaderView?.frame.height ?? 0), tableView.visibleCells.count > 0 {
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: tableView.tableHeaderView == nil)
                }
                
                // scroll to visible rect(1,1) when content did scroll
                if didScroll {
                    tableView.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)
                }
            } else {
                if tableView.visibleCells.count > 0 {
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: tableView.tableHeaderView == nil)
                }
            }
            
            return false
        }
        
        if let scrollView = topViewController.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            scrollView.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)
            return false
        }
        
        return true
    }
}
