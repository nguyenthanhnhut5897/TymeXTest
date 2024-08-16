//
//  Strings.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import Foundation


struct ChillLocalization {
    
    static var shared = ChillLocalization()
    
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
extension ChillLocalization {
    
    /// Return defined string based on corresponding target table and key.
    internal func string(forKey key: String, in table: Table = .localizable) -> String {
        return Bundle.main.localizedString(forKey: key, value: nil, table: table.name)
    }
    
}


struct Strings {}


// Generals
extension Strings {
    static var OKTitle : String {
        return ChillLocalization.shared.string(forKey: "OK")
    }
    static var YesTitle : String {
        return ChillLocalization.shared.string(forKey: "Yes")
    }
    static var CancelTitle : String {
        return ChillLocalization.shared.string(forKey: "Cancel")
    }
    static var ErrorTitle : String {
        return ChillLocalization.shared.string(forKey: "Error")
    }
}

// Login
extension Strings {
    static var loginTitle : String {
        return ChillLocalization.shared.string(forKey: "Login")
    }
}
