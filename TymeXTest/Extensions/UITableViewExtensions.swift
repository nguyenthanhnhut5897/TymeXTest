//
//  UITableViewExtensions.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import UIKit

extension UITableView {
    func regisCells(_ cellIdentifiers: String...) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
        }
    }
}