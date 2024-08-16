//
//  DictionaryExtensions.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import Foundation

extension Dictionary where Key == String, Value == Optional<Any> {
    func discardNil() -> [Key: Any] {
        return self.compactMapValues({ $0 })
    }
}
