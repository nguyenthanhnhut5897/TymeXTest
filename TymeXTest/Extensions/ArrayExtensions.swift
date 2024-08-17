//
//  ArrayExtensions.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
