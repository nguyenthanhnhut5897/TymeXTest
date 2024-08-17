//
//  UIViewExtensions.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/10.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: (layer.borderColor ?? UIColor.clear.cgColor))
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    func constrainToEdges(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func roundCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func roundCornersAndDropShadow(cRadius: CGFloat, sColor: UIColor, sOpacity: Float, sOffset: CGSize, sBlur: CGFloat, sSpread: CGFloat) {
        layer.cornerRadius = cRadius
        layer.shadowColor = sColor.cgColor
        layer.shadowOpacity = sOpacity
        layer.shadowOffset = sOffset
        layer.shadowRadius = sBlur / 2
        if sSpread == 0 {
            layer.shadowPath = nil
        } else {
            layer.shadowPath = UIBezierPath(rect: bounds.insetBy(dx: -sSpread, dy: -sSpread)).cgPath
        }
        layer.masksToBounds = false
        clipsToBounds = false
    }
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        
        for subView in subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
    
    @discardableResult
    func addLineDashedStroke(boundSize: CGRect?, pattern: [NSNumber]?, radius: CGFloat, color: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let borderLayer = CAShapeLayer()
        
        borderLayer.lineWidth = lineWidth
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = boundSize ?? bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: boundSize ?? bounds, cornerRadius: radius).cgPath
        
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    /// Find a last label in view
    func getALabel() -> UILabel? {
        var aLabel: UILabel?
        
        self.subviews.forEach { subView in
            if let label = subView as? UILabel {
                aLabel = label
            }else if let label = subView.getALabel() {
                aLabel = label
            }
        }
        
        return aLabel
    }
    
    func clipToBoundViewAndSubviews(_ isBound: Bool) {
        clipsToBounds = isBound
        
        subviews.forEach { view in
            view.clipToBoundViewAndSubviews(isBound)
        }
    }
}
