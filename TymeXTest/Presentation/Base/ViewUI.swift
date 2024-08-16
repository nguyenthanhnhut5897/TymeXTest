//
//  ViewUI.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/04.
//

import UIKit

enum ScreenSize: CGFloat {
    case screenSize4Inch = 320
    case screenSize4p7Inch = 375
}

struct ViewUI {
    static let Padding: CGFloat = 8
    static let ButtonHeight: CGFloat = 48
    static let TextFieldHeight: CGFloat = 48
    static let TextViewHeight: CGFloat = 80
    
    static var isSEScreen: Bool {
        return UIScreen.main.bounds.width <= ScreenSize.screenSize4Inch.rawValue
    }
    
    static var VerticalPadding: CGFloat {
        guard UIScreen.main.bounds.width < ScreenSize.screenSize4p7Inch.rawValue else {
            return Padding
        }
        
        return Padding / 2
    }
    
    static var StatusBarHeight: CGFloat {
        return UIWindow.key?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var MainBottomInset: CGFloat {
        return UIWindow.key?.safeAreaInsets.bottom ?? 0
    }
}

extension UIWindow {
    static var key: UIWindow? {
        #warning("Need to update it based on the window that is presenting (there are multi window form iOS 13")
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}
