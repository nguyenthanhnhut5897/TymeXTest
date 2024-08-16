//
//  UserRepositoryHandler.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/07.
//

import iOSAPIService

final class UserRepositoryHandler {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension UserRepositoryHandler: UserRepository {
    func getUserProfile(query: UserProfileParams, cached: @escaping (CUser?) -> Void, completion: @escaping (Result<CUser?, Error>) -> Void) -> SessionCancellable? {
        let request = GetUserProfileRequest(param: query)
        return dataTransferService.send(request: request) { (result, data) in
            switch result {
            case .success(let ress):
                completion(.success(ress.transferToUser()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUsersList(query: GetUserListParams, cached: @escaping ([CUser]?) -> Void, completion: @escaping (Result<[CUser]?, Error>) -> Void) -> SessionCancellable? {
        
        let request = GetUserListRequest(param: query)
        return dataTransferService.send(request: request) { (result, data) in
            switch result {
            case .success(let ress):
                completion(.success(ress.compactMap({ $0.transferToUser() })))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        cache.getResponse(for: requestDTO) { result in
//
//            if case let .success(responseDTO?) = result {
//                cached(responseDTO.toDomain())
//            }
//            guard !task.isCancelled else { return }
//
//            let endpoint = APIEndpoints.getMovies(with: requestDTO)
//            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
//                switch result {
//                case .success(let responseDTO):
//                    self.cache.save(response: responseDTO, for: requestDTO)
//                    completion(.success(responseDTO.toDomain()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
    }
}
