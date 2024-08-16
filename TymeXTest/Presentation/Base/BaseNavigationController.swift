//
//  BaseNavigationController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/15.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var shouldShowStatusBarLightContent = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return shouldShowStatusBarLightContent ? .lightContent : .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .fullScreen
        navigationBar.tintColor = .black
        navigationBar.backIndicatorImage = UIImage(named: "navigation_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "navigation_back")
    }
}
