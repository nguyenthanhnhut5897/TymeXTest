//
//  UserUseCaseTests.swift
//  TymeXTestTests
//
//  Created by Thanh Nhut on 18/8/24.
//

import XCTest
@testable import TymeXTest

final class UserUseCaseTests: XCTestCase {
    
    let userList: [GUser] = {
        var users: [GUser] = []
        
        for i in 0..<20 {
            users.append(GUser(username: "username\(i)", landingPageUrl: "", avatarUrl: "", location: "hcm", followers: Int.random(in: 0...1000), following: Int.random(in: 0...1000)))
        }
        
        return users
    }()
    
    class UserRepositoryHandlerMock: UserRepository {
        var result: Result<[GUser]?, Error>
        var cacheResult: [GUser]?
        var fetchUsersCompletionCount: Int = 0

        init(result: Result<[GUser]?, Error>, cacheResult: [GUser]?) {
            self.result = result
            self.cacheResult = cacheResult
        }

        func getUserProfile(query: UserProfileParams, completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable? {
            switch result {
            case .success(let users):
                completion(.success(users?.first(where: { $0.username == query.username })))
            case .failure(let error):
                completion(.failure(error))
            }
            
            fetchUsersCompletionCount += 1
            
            return RepositoryTask()
        }
        
        func getUsersList(query: GetUserListParams, cached: @escaping ([GUser]?) -> Void, completion: @escaping (Result<[GUser]?, Error>) -> Void) -> TaskCancellable? {
            
            cached(cacheResult)
            completion(result)
            fetchUsersCompletionCount += 1
            
            return RepositoryTask()
        }
    }
    
    /// test fetch user list successful
    func testFetchUsersSuccessfulUseCase() {
        let moviesRepository = UserRepositoryHandlerMock(result: .success(userList),
                                                         cacheResult: nil)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let perPage: Int = 20
        let query = GetUserListParams(page: 0, perPage: perPage)
        var result = [GUser]()
        var cache = [GUser]()
        
        useCase.getUsersList(params: query) { users in
            cache = users ?? []
        } completion: { res in
            switch res {
            case .success(let users):
                result = users ?? []
            case .failure: break
            }
        }
        
        XCTAssertTrue(result.count == perPage)
        XCTAssertTrue(result.contains(where: { $0.username == "username0" }))
        XCTAssertTrue(cache.isEmpty)
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
    
    /// test fetch user list successful from api and cache
    func testFetchUsersSuccessfulUseCase_hasCached() {
        let moviesRepository = UserRepositoryHandlerMock(result: .success(userList),
                                                         cacheResult: userList)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let perPage: Int = 20
        let query = GetUserListParams(page: 0, perPage: perPage)
        var result = [GUser]()
        var cache = [GUser]()
        
        useCase.getUsersList(params: query) { users in
            cache = users ?? []
        } completion: { res in
            switch res {
            case .success(let users):
                result = users ?? []
            case .failure: break
            }
        }
        
        XCTAssertTrue(result.count == perPage)
        XCTAssertTrue(result.contains(where: { $0.username == "username0" }))
        XCTAssertTrue(cache.count == perPage)
        XCTAssertTrue(cache.contains(where: { $0.username == "username0" }))
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
    
    /// test fetch user list failed
    func testFetchUsersFailedUseCase() {
        let moviesRepository = UserRepositoryHandlerMock(result: .failure(NSError(domain: "", code: 600)),
                                                         cacheResult: nil)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let perPage: Int = 20
        let query = GetUserListParams(page: 0, perPage: perPage)
        var result = [GUser]()
        var cache = [GUser]()
        var error: Error?
        
        useCase.getUsersList(params: query) { users in
            cache = users ?? []
        } completion: { res in
            switch res {
            case .success(let users):
                result = users ?? []
            case .failure(let err):
                error = err
            }
        }
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertTrue(cache.isEmpty)
        XCTAssertTrue(error != nil)
        XCTAssertTrue(error?.code == 600)
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
    
    /// test fetch user list failed from api and successful from cache
    func testFetchUsersFailedUseCase_hasCached() {
        let moviesRepository = UserRepositoryHandlerMock(result: .failure(NSError(domain: "", code: 600)),
                                                         cacheResult: userList)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let perPage: Int = 20
        let query = GetUserListParams(page: 0, perPage: perPage)
        var result = [GUser]()
        var cache = [GUser]()
        var error: Error?
        
        useCase.getUsersList(params: query) { users in
            cache = users ?? []
        } completion: { res in
            switch res {
            case .success(let users):
                result = users ?? []
            case .failure(let err):
                error = err
            }
        }
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertTrue(error != nil)
        XCTAssertTrue(error?.code == 600)
        XCTAssertTrue(cache.count == perPage)
        XCTAssertTrue(cache.contains(where: { $0.username == "username0" }))
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
    
    /// test fetch user profile successful
    func testFetchUserProfileSuccessfulUseCase() {
        let moviesRepository = UserRepositoryHandlerMock(result: .success(userList),
                                                         cacheResult: nil)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let params = UserProfileParams(username: "username3")
        var result: GUser?
        
        useCase.getUserProfile(params: params) { res in
            switch res {
            case .success(let user):
                result = user
            case .failure: break
            }
        }
        
        XCTAssertTrue(result != nil)
        XCTAssertTrue(result?.username == "username3")
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
    
    /// test fetch user profile failed
    func testFetchUserProfileFailedUseCase() {
        let moviesRepository = UserRepositoryHandlerMock(result: .failure(NSError(domain: "", code: 602)),
                                                         cacheResult: nil)
        let useCase = UserUseCaseHandler(userRepository: moviesRepository)
        let params = UserProfileParams(username: "username3")
        var result: GUser?
        var error: Error?
        
        useCase.getUserProfile(params: params) { res in
            switch res {
            case .success(let user):
                result = user
            case .failure(let err):
                error = err
            }
        }
        
        XCTAssertTrue(result == nil)
        XCTAssertTrue(error != nil)
        XCTAssertTrue(error?.code == 602)
        XCTAssertEqual(moviesRepository.fetchUsersCompletionCount, 1)
    }
}
