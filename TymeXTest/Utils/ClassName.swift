//
//  ClassName.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import Foundation

protocol ClassName {
    static var className: String { get }
}

extension NSObject: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
