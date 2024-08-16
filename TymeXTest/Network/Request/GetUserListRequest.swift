//
//  GetUserListRequest.swift
//  YourEyes
//
//  Created by Nguyen Thanh Nhut on 2022/07/10.
//

import iOSAPIService

struct GetUserListRequest: Requestable {
    
    typealias Response = [CUserDTO]
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/users"
    }
    
    var headerField: [String : String] {
        return ["Content-Type" : "application/json;charset=utf-8"]
    }
    
    var queryParameters: [String : Any] {
        return param?.queryParameters ?? [:]
    }
    
    var param: GetUserListParams?
    
    init(param: GetUserListParams? = nil) {
        self.param = param
    }
}
