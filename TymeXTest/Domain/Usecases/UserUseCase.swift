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
        cached: @escaping ([CUser]?) -> Void,
        completion: @escaping (Result<[CUser]?, Error>) -> Void
    ) -> SessionCancellable?
    
    @discardableResult
    func getUserProfile(
        params: UserProfileParams,
        cached: @escaping (CUser?) -> Void,
        completion: @escaping (Result<CUser?, Error>) -> Void
    ) -> SessionCancellable?
}

final class UserUseCaseHandler: UserUseCase {

    private let userRepository: UserRepository
    private let userRepositoryCaches: UserRepositoryCaches

    init(
        userRepository: UserRepository,
        userRepositoryCaches: UserRepositoryCaches
    ) {
        self.userRepository = userRepository
        self.userRepositoryCaches = userRepositoryCaches
    }
    
    @discardableResult
    func getUsersList(params: GetUserListParams,
               cached: @escaping ([CUser]?) -> Void,
               completion: @escaping (Result<[CUser]?, Error>) -> Void) -> SessionCancellable?
    {
        return userRepository.getUsersList(query: params, cached: cached) { result in
            if case .success = result {
                self.userRepositoryCaches.saveRecentUserListQuery(query: params) { _ in }
            }
            
            completion(result)
        }
    }
    
    @discardableResult
    func getUserProfile(params: UserProfileParams,
                       cached: @escaping (CUser?) -> Void,
                       completion: @escaping (Result<CUser?, Error>) -> Void) -> SessionCancellable?
    {
        return userRepository.getUserProfile(query: params, cached: cached) { result in
            if case .success = result {
                self.userRepositoryCaches.saveRecentUserQuery(query: params) { _ in }
            }
            
            completion(result)
        }
    }
}
