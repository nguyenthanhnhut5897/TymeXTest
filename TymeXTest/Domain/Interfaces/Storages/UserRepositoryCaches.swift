//
//  UserRepositoryCaches.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import Foundation

protocol UserRepositoryCaches {
    
    /// Save a list of users to storage
    /// - Parameters:
    ///   - users: users list that need to save
    ///   - completion: return success with user info that has saved or failed with an error
    func saveRecentUserListQuery(
        users: [GUser],
        completion: @escaping (Result<[GUser], Error>) -> Void
    )
    
    /// Fetch a list of users from storage
    /// - Parameters:
    ///   - query: query object, that include page and per page
    ///   - completion: return success with a list of user or failed with an error
    func fetchRecentUserListQuery(
        query: GetUserListParams,
        completion: @escaping (Result<[GUser], Error>) -> Void
    )
}
