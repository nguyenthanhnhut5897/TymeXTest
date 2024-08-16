//
//  CBaseViewController.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/04.
//

import UIKit
import SafariServices

open class MQBaseTableViewController: UITableViewController {
    class func viewController() -> UIViewController? { return nil }
}

extension UIViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? CTabbarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
    /// Try to dismiss all presented screen until finish
    /// completion: handle something after dismiss finish
    class func dismissSpecialTopViewController(completion: @escaping (() -> Void)) {
        #warning("Iplement again")
//        if let presentedVC = AppDelegate.default.tabbarController?.selectedViewController?.presentedViewController {
//            presentedVC.dismiss(animated: true, completion: {
//                dismissSpecialTopViewController(completion: completion)
//            })
//        } else {
//            completion()
//        }
    }
}


open class CBaseViewController: UIViewController {
    var orientationMask: UIInterfaceOrientationMask {
        return .portrait
    }
    var shouldUnlockOrientationMask: Bool {
        return false
    }
    
    override open var interfaceOrientation: UIInterfaceOrientation {
        return .portrait
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupOrientationMask()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    open func setupOrientationMask() {}
    open func setupViews() {}
    open func updateLayout() {}
}

open class CBaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    public override init() {
        super.init()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayout()
    }
    
    open func configureLayout() {}
}

extension UIView {
    @discardableResult
    public func addSubviews(_ subviews: UIView...) -> UIView {
        subviews.forEach { addSubview($0) }
        return self
    }
}

extension CALayer {
    public func addSublayers(_ sublayers: CALayer...) -> CALayer {
        sublayers.forEach { addSublayer($0) }
        return self
    }
}
