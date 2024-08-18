//
//  UserRepositoryHandler.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import iOSAPIService

final class UserRepositoryHandler {
    private let dataTransferService: DataTransferService
    private let cache: UserRepositoryCaches

    init(dataTransferService: DataTransferService, cache: UserRepositoryCaches) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension UserRepositoryHandler: UserRepository {
    func getUserProfile(query: UserProfileParams, cached: @escaping (GUser?) -> Void, completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable? {
        
        let task = RepositoryTask()
        let request = GetUserProfileRequest(param: query)
        
        task.networkTask = dataTransferService.send(request: request) { [weak self] (result, data) in
            switch result {
            case .success(let ress):
                let users = [ress.transferToUser()]
                self?.cache.saveRecentUserListQuery(users: users, completion: { _ in })
                completion(.success(ress.transferToUser()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
    
    func getUsersList(query: GetUserListParams, cached: @escaping ([GUser]?) -> Void, completion: @escaping (Result<[GUser]?, Error>) -> Void) -> TaskCancellable? {
        let task = RepositoryTask()
        
        if query.page != 0 {
            task.networkTask = getUsersList(query: query, completion: completion)
        } else {
            cache.fetchRecentUserListQuery(query: query) { [weak self] result in
                switch result {
                case .success(let users):
                    cached(users)
                case .failure(let error):
                    print(error)
                }
                
                guard !task.isCancelled else { return }
                
                task.networkTask = self?.getUsersList(query: query, completion: completion)
            }
        }
        
        return task
    }
    
    private func getUsersList(query: GetUserListParams, completion: @escaping (Result<[GUser]?, Error>) -> Void) -> SessionCancellable? {
        let request = GetUserListRequest(param: query)
        
        return dataTransferService.send(request: request) { [weak self] (result, data) in
            switch result {
            case .success(let ress):
                let users = ress.compactMap({ $0.transferToUser() })
                self?.cache.saveRecentUserListQuery(users: users, completion: { _ in })
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
