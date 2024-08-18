//
//  UserRepositoryCaches.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import Foundation

protocol UserRepositoryCaches {
    func saveRecentUserListQuery(
        users: [GUser],
        completion: @escaping (Result<[GUser], Error>) -> Void
    )
    
    func fetchRecentUserListQuery(
        query: GetUserListParams,
        completion: @escaping (Result<[GUser], Error>) -> Void
    )
}
