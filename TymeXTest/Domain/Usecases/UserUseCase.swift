//
//  UserUseCase.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/05.
//

import iOSAPIService

protocol UserUseCase: CUseCase {
    @discardableResult
    func getUsersList(
        params: GetUserListParams,
        cached: @escaping ([GUser]?) -> Void,
        completion: @escaping (Result<[GUser]?, Error>) -> Void
    ) -> TaskCancellable?
    
    @discardableResult
    func getUserProfile(
        params: UserProfileParams,
        cached: @escaping (GUser?) -> Void,
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
                       cached: @escaping (GUser?) -> Void,
                       completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable?
    {
        return userRepository.getUserProfile(query: params, cached: cached) { result in
            completion(result)
        }
    }
}
