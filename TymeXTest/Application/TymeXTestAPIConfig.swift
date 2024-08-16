//
//  TymeXTestAPIConfig.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/15.
//

import Foundation

class TymeXTestAPIConfig {
    lazy var apiBaseURL: URL = {
        return URL(string: "https://api.github.com")!
//        guard let apiBaseURLString = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
//            fatalError("ApiBaseURL must not be empty in plist")
//        }
//        
//        guard let apiBaseURL = URL(string: apiBaseURLString) else {
//            fatalError("ApiBaseURL must be an url")
//        }
//        
//        return apiBaseURL
    }()
}
