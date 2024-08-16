//
//  HideKeyboardable.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import UIKit

protocol HideKeyboardable: AnyObject {
    func addHideKeyboardWhenTappedAround()
}

extension HideKeyboardable where Self: BaseViewController {
    func addHideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
