//
//  Strings.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import Foundation


struct TymeXTestLocalization {
    
    static var shared = TymeXTestLocalization()
    
    internal enum Table: String {
        case `default`
        case localizable
        
        public var name: String? {
            switch self {
            case .localizable:
                return "Localizable"
            default:
                return nil
            }
        }
    }
}


// MARK: - Supports
//
extension TymeXTestLocalization {
    
    /// Return defined string based on corresponding target table and key.
    internal func string(forKey key: String, in table: Table = .localizable) -> String {
        return Bundle.main.localizedString(forKey: key, value: nil, table: table.name)
    }
    
}


struct Strings {}

// Generals
extension Strings {
    static var OKTitle : String {
        return "OK".textLocalized
    }
    static var YesTitle : String {
        return "Yes".textLocalized
    }
    static var CancelTitle : String {
        return "Cancel".textLocalized
    }
    static var ErrorTitle : String {
        return "Error".textLocalized
    }
}
