//
//  OnMainThreadExecutor.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/04.
//

import Foundation

public func executeBlockOnMainIfNeeded(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
