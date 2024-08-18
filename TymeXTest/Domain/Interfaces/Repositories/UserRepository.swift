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
        cached: @escaping (GUser?) -> Void,
        completion: @escaping (Result<GUser?, Error>) -> Void
    ) -> TaskCancellable?
    
    @discardableResult
    func getUsersList(
        query: GetUserListParams,
        cached: @escaping ([GUser]?) -> Void,
        completion: @escaping (Result<[GUser]?, Error>) -> Void
    ) -> TaskCancellable?
}
