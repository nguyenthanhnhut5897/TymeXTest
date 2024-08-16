//
//  UserRepository.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import iOSAPIService

protocol UserRepository: CRepository {
    @discardableResult
    func getUserProfile(
        query: UserProfileParams,
        cached: @escaping (CUser?) -> Void,
        completion: @escaping (Result<CUser?, Error>) -> Void
    ) -> SessionCancellable?
    
    @discardableResult
    func getUsersList(
        query: GetUserListParams,
        cached: @escaping ([CUser]?) -> Void,
        completion: @escaping (Result<[CUser]?, Error>) -> Void
    ) -> SessionCancellable?
}
