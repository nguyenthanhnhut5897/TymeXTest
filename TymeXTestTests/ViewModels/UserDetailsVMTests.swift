//
//  UserDetailsVMTests.swift
//  TymeXTestTests
//
//  Created by Thanh Nhut on 19/8/24.
//

import XCTest
@testable import TymeXTest

final class UserDetailsVMTests: XCTestCase {
    static let userInfo = GUser(username: "username", landingPageUrl: "", avatarUrl: "", location: "hcm", followers: Int.random(in: 0...1000), following: Int.random(in: 0...1000))
    
    class FetchUserProfileUseCaseMock: UserUseCase {
        var executeCallCount: Int = 0
        
        typealias ExecuteBlock = (
            UserProfileParams,
            (Result<GUser?, Error>) -> Void
        ) -> Void
        
        lazy var _execute: ExecuteBlock = { _, _ in
            XCTFail("not implemented")
        }
        
        @discardableResult
        func getUsersList(params: GetUserListParams,
                          cached: @escaping ([GUser]?) -> Void,
                          completion: @escaping (Result<[GUser]?, Error>) -> Void) -> TaskCancellable?
        {
            return nil
        }
        
        @discardableResult
        func getUserProfile(params: UserProfileParams,
                            completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable?
        {
            executeCallCount += 1
            _execute(params, completion)
            return nil
        }
    }
    
    func testFetchUserProfileUseCaseHasData() {
        let fetchUserProfileUseCaseMock = FetchUserProfileUseCaseMock()

        fetchUserProfileUseCaseMock._execute = { requestValue, completion in
            XCTAssertEqual(requestValue.username, UserDetailsVMTests.userInfo.username)
            completion(.success(UserDetailsVMTests.userInfo))
        }
        
        let selectUser = GUser(username: "username", landingPageUrl: "", avatarUrl: "", location: nil, followers: nil, following: nil)
        let vm = UserDetailsVM(user: selectUser, userUsecase: fetchUserProfileUseCaseMock)
        vm.fetchData()
        let expectedUser = UserDetailsVMTests.userInfo
        
        XCTAssertEqual(vm.userInfo.value, expectedUser)
        XCTAssertEqual(fetchUserProfileUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    func testFetchUserProfileUseCaseError() {
        let fetchUserProfileUseCaseMock = FetchUserProfileUseCaseMock()

        fetchUserProfileUseCaseMock._execute = { requestValue, completion in
            XCTAssertEqual(requestValue.username, UserDetailsVMTests.userInfo.username)
            completion(.failure(NSError(domain: "", code: 605)))
        }
        
        let selectUser = GUser(username: "username", landingPageUrl: "", avatarUrl: "", location: nil, followers: nil, following: nil)
        let vm = UserDetailsVM(user: selectUser, userUsecase: fetchUserProfileUseCaseMock)
        vm.fetchData()
        let expectedUser = UserDetailsVMTests.userInfo
        
        XCTAssertNotNil(vm.error.value)
        XCTAssertTrue(vm.error.value?.code == 605)
        XCTAssertNotEqual(vm.userInfo.value, expectedUser)
        XCTAssertEqual(vm.userInfo.value?.username, expectedUser.username)
        XCTAssertEqual(fetchUserProfileUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
}
