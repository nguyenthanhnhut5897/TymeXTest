//
//  GetUserListParams.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/05.
//

import Foundation

struct GetUserListParams {
    var page: Int?
    var perPage: Int?
    
    var queryParameters: [String : Any] {
        let dict: [String: Any?] = ["page": page,
                                    "per_page": perPage]
        return dict.discardNil()
    }
}
