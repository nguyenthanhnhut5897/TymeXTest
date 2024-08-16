//
//  UIColorExtensions.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import UIKit

extension UIColor {
    struct TymeXTest {
        static let primaryColor = UIColor(rgb: 0xfff000)
        static let textColor = UIColor.fromRGB(35, 25, 22)
        static let disableTextColor = UIColor(rgb: 0x585350)
        static let placeholderTextColor = UIColor(rgb: 0xc1c0bb)
        static let borderColor = UIColor(rgb: 0xC7C7CC)
        static let linkColor = UIColor.fromRGB(0, 163, 223)
        static let backgroundColor = UIColor.fromRGB(241, 245, 248)
        static let buttonColor = UIColor.fromRGB(255, 218, 26)
        static let lineColor = UIColor(rgb: 0xe7e7e7)
        static let errorTextColor = UIColor(rgb: 0xe62a2a)
        static let unreadNotiColor = UIColor(rgb: 0xfffde0)
        static let subTextColor = UIColor.fromRGB(35, 25, 22, alpha: 0.48)
        static let cancelColor = UIColor.fromRGB(255, 59, 48)
        static let transparentColor = UIColor.fromRGB(0, 0, 0, alpha: 0)
    }
    
    /**
     * Initializes and returns a color object for the given RGB hex integer.
     */
    public convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue: CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: 1)
    }
    
    public convenience init(rgba: UInt32) {
        self.init(
            red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgba & 0x00FF0000) >> 16)  / 255.0,
            blue: CGFloat((rgba & 0x0000FF00) >> 8)  / 255.0,
            alpha: CGFloat((rgba & 0x000000FF) >> 0) / 255.0
        )
    }
    
    public convenience init(colorString: String) {
        var colorInt: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&colorInt)
        self.init(rgb: (Int) (colorInt))
    }
    
    static func fromRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
