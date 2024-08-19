//
//  UserUseCase.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/05.
//

import iOSAPIService

protocol UserUseCase: CUseCase {
    
    /// Fetch a list of users
    /// - Parameters:
    ///   - query: query object, that include page and per page
    ///   - cached: return user list that has cached in storage if any
    ///   - completion: return success with a list of user or failed with an error
    /// - Returns: return a fetch user list task
    @discardableResult
    func getUsersList(
        params: GetUserListParams,
        cached: @escaping ([GUser]?) -> Void,
        completion: @escaping (Result<[GUser]?, Error>) -> Void
    ) -> TaskCancellable?
    
    /// Fetch a profile of an user
    /// - Parameters:
    ///   - query: query object
    ///   - completion: return success with user info or failed with an error
    /// - Returns: return a fetch profile task
    @discardableResult
    func getUserProfile(
        params: UserProfileParams,
        completion: @escaping (Result<GUser?, Error>) -> Void
    ) -> TaskCancellable?
}

final class UserUseCaseHandler: UserUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    @discardableResult
    func getUsersList(params: GetUserListParams,
                      cached: @escaping ([GUser]?) -> Void,
                      completion: @escaping (Result<[GUser]?, Error>) -> Void) -> TaskCancellable? 
    {
        return userRepository.getUsersList(query: params, cached: cached) { result in
            completion(result)
        }
    }
    
    @discardableResult
    func getUserProfile(params: UserProfileParams,
                       completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable?
    {
        return userRepository.getUserProfile(query: params) { result in
            completion(result)
        }
    }
}
