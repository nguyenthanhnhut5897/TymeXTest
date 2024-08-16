//
//  GetUserProfileRequest.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import iOSAPIService

struct GetUserProfileRequest: Requestable {
    
    typealias Response = CUserDTO
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/users/\(param?.username ?? "")"
    }
    
    var headerField: [String : String] {
        return ["Content-Type" : "application/json;charset=utf-8"]
    }
    
    var param: UserProfileParams?
    
    init(param: UserProfileParams? = nil) {
        self.param = param
    }
}
