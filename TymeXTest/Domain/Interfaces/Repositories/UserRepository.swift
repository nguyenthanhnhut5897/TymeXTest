//
//  UserRepository.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import iOSAPIService

protocol UserRepository: CRepository {
    
    /// Fetch a profile of an user
    /// - Parameters:
    ///   - query: query object
    ///   - completion: return success with user info or failed with an error
    /// - Returns: return a fetch profile task
    @discardableResult
    func getUserProfile(
        query: UserProfileParams,
        completion: @escaping (Result<GUser?, Error>) -> Void
    ) -> TaskCancellable?
    
    /// Fetch a list of users
    /// - Parameters:
    ///   - query: query object, that include page and per page
    ///   - cached: return user list that has cached in storage if any
    ///   - completion: return success with a list of user or failed with an error
    /// - Returns: return a fetch user list task
    @discardableResult
    func getUsersList(
        query: GetUserListParams,
        cached: @escaping ([GUser]?) -> Void,
        completion: @escaping (Result<[GUser]?, Error>) -> Void
    ) -> TaskCancellable?
}
