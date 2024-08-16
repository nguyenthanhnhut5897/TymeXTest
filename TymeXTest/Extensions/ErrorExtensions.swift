//
//  ErrorExtensions.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/11.
//

import UIKit

extension Error {
    var title: String? { return getErrorTitle() }
    var message: String { return getErrorMessage() }
    var codeValue: Int {
        if let data = (userInfo["NSLocalizedDescription"] as? String)?.convertToDict(), let code = data["code"] as? Int {
            return code
        }
        
        return 0
    }
    
    var comfirmTitle: String {
        switch code {
        case ErrorCode.ForceUpdateAppVersion:
            return Strings.YesTitle
        default:
            return Strings.OKTitle
        }
    }
    
    func getErrorTitle() -> String {
        switch code {
        case ErrorCode.ForceUpdateAppVersion:
            return Strings.ErrorTitle
        default:
            return ""
        }
    }
    
    func getErrorMessage() -> String {
        switch code {
        case ErrorCode.ForceUpdateAppVersion:
            return Strings.ErrorTitle
        default:
            return self.localizedDescription
        }
    }
    
    func getConfirmAction(okAction: (() -> Void)? = nil, completionHandler: (() -> Void)? = nil) -> (() -> Void)? {
        switch code {
        case ErrorCode.ForceUpdateAppVersion:
            return {
                #warning("change the ituneslink")
                if let itunesURL = URL(string: "Constants.itunesLink"), UIApplication.shared.canOpenURL(itunesURL) {
                    UIApplication.shared.open(itunesURL, options: [:], completionHandler: { value in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                            completionHandler?()
                        }
                    })
                }
            }
        default:
            return okAction
        }
    }
}
