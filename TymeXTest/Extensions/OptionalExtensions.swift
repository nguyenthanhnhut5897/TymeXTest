//
//  OptionalExtensions.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import Foundation

extension Optional {
    
    func unwrap(_ closure: (Wrapped) -> Void) {
        self.map(closure)
    }
    
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        guard let value = self else {
            return defaultValue
        }
        return value
    }
}
