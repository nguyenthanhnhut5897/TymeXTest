//
//  HomeViewModelTests.swift
//  TymeXTestTests
//
//  Created by Thanh Nhut on 19/8/24.
//

import XCTest
@testable import TymeXTest

final class HomeViewModelTests: XCTestCase {
    static let userList: [GUser] = {
        var users: [GUser] = []
        
        for i in 0..<40 {
            users.append(GUser(username: "username\(i)", landingPageUrl: "", avatarUrl: "", location: "hcm", followers: Int.random(in: 0...1000), following: Int.random(in: 0...1000)))
        }
        
        return users
    }()
    
    class FetchUsersUseCaseMock: UserUseCase {
        var executeCallCount: Int = 0

        typealias ExecuteBlock = (
            GetUserListParams,
            ([GUser]?) -> Void,
            (Result<[GUser]?, Error>) -> Void
        ) -> Void

        lazy var _execute: ExecuteBlock = { _, _, _ in
            XCTFail("not implemented")
        }
        
        @discardableResult
        func getUsersList(params: GetUserListParams,
                          cached: @escaping ([GUser]?) -> Void,
                          completion: @escaping (Result<[GUser]?, Error>) -> Void) -> TaskCancellable?
        {
            executeCallCount += 1
            _execute(params, cached, completion)
            return nil
        }
        
        @discardableResult
        func getUserProfile(params: UserProfileParams,
                           completion: @escaping (Result<GUser?, Error>) -> Void) -> TaskCancellable?
        {
            return nil
        }
    }
    
    /// test fetching user list in no data case
    func testFetchUserListEmptyUseCase() {
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()

        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 0)
            completion(.success([]))
        }
        
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        vm.fetchData(isRefresh: true)
        
        XCTAssertEqual(vm.page, 1)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.hasMoreData)
        XCTAssertTrue(vm.userList.value.isEmpty)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list at the first page successful
    func testFetchUserListFirstPageUseCase() {
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()

        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 0)
            completion(.success(Array(HomeViewModelTests.userList.prefix(20))))
        }
        
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        vm.fetchData(isRefresh: true)
        let expectedItems = Array(HomeViewModelTests.userList.prefix(20))
        
        XCTAssertEqual(vm.page, 1)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.hasMoreData)
        XCTAssertEqual(vm.userList.value, expectedItems)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list at the first page then fetching the second page successful
    func testFetchUserListSecondPageUseCase() {
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()

        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 0)
            completion(.success(Array(HomeViewModelTests.userList.prefix(20))))
        }
        
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        vm.fetchData(isRefresh: true)
        
        XCTAssertEqual(vm.page, 1)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        
        var userList = Array(HomeViewModelTests.userList[20..<HomeViewModelTests.userList.count])
        userList = Array(userList.prefix(20))
        
        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)
            completion(.success(userList))
        }
        vm.loadMoreIfNeed()
        
        let expectedItems = HomeViewModelTests.userList
        
        XCTAssertEqual(vm.page, 2)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.hasMoreData)
        XCTAssertEqual(vm.userList.value, expectedItems)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 2)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list at the last page successful and there is no more data
    func testFetchUserListLastPageUseCase_noMoreData() {
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()

        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 0)
            completion(.success(Array(HomeViewModelTests.userList.prefix(20))))
        }
        
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        vm.fetchData(isRefresh: true)
        XCTAssertEqual(vm.page, 1)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        
        var userList = Array(HomeViewModelTests.userList[20..<HomeViewModelTests.userList.count])
        userList = Array(userList.prefix(20))
        
        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 1)
            completion(.success(userList))
        }
        vm.loadMoreIfNeed()
        XCTAssertEqual(vm.page, 2)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 2)
        
        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 2)
            completion(.success([]))
        }
        vm.loadMoreIfNeed()
        
        let expectedItems = HomeViewModelTests.userList
        
        XCTAssertEqual(vm.page, 3)
        XCTAssertFalse(vm.isLoading)
        XCTAssertFalse(vm.hasMoreData)
        XCTAssertEqual(vm.userList.value, expectedItems)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 3)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list failed
    func testFetchUserListUseCaseReturnsError() {
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()

        fetchUsersUseCaseMock._execute = { requestValue, _, completion in
            XCTAssertEqual(requestValue.page, 0)
            completion(.failure(NSError(domain: "", code: 601)))
        }
        
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        vm.fetchData(isRefresh: true)
        
        XCTAssertEqual(vm.page, 0)
        XCTAssertFalse(vm.isLoading)
        XCTAssertTrue(vm.hasMoreData)
        XCTAssertNotNil(vm.error.value)
        XCTAssertTrue(vm.error.value?.code == 601)
        XCTAssertTrue(vm.userList.value.isEmpty)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list -> receive cache data first -> receive data from api
    func testFetchUserListUseCaseReturnCachedData() {
        var cachedUsers: [GUser] = []
        
        for i in 0..<20 {
            cachedUsers.append(GUser(username: "cacheUsername\(i)", landingPageUrl: "", avatarUrl: "", location: "hcm", followers: Int.random(in: 0...1000), following: Int.random(in: 0...1000)))
        }
        
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        
        let testItemsBeforeFreshData = { [weak vm] in
            guard let vm else { return }
            XCTAssertEqual(vm.userList.value, cachedUsers)
        }

        fetchUsersUseCaseMock._execute = { requestValue, cached, completion in
            XCTAssertEqual(requestValue.page, 0)
            cached(cachedUsers)
            testItemsBeforeFreshData()
            completion(.success(Array(HomeViewModelTests.userList.prefix(20))))
        }
        
        vm.fetchData(isRefresh: true)
        
        let expectedItems = Array(HomeViewModelTests.userList.prefix(20))
        
        XCTAssertEqual(vm.userList.value, expectedItems)
        XCTAssertEqual(vm.page, 1)
        XCTAssertTrue(vm.hasMoreData)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
    
    /// test fetching user list -> receive cache data first -> receive an error from api
    func testFetchUserListUseCaseReturnErrorAndShowCachedData() {
        var cachedUsers: [GUser] = []
        
        for i in 0..<20 {
            cachedUsers.append(GUser(username: "cacheUsername\(i)", landingPageUrl: "", avatarUrl: "", location: "hcm", followers: Int.random(in: 0...1000), following: Int.random(in: 0...1000)))
        }
        
        let fetchUsersUseCaseMock = FetchUsersUseCaseMock()
        let vm = HomeViewModel(userUsecase: fetchUsersUseCaseMock)
        
        let testItemsBeforeFreshData = { [weak vm] in
            guard let vm else { return }
            XCTAssertEqual(vm.userList.value, cachedUsers)
        }

        fetchUsersUseCaseMock._execute = { requestValue, cached, completion in
            XCTAssertEqual(requestValue.page, 0)
            cached(cachedUsers)
            testItemsBeforeFreshData()
            completion(.failure(NSError(domain: "", code: 604)))
        }
        
        vm.fetchData(isRefresh: true)
        
        XCTAssertEqual(vm.userList.value, cachedUsers)
        XCTAssertEqual(vm.page, 1)
        XCTAssertTrue(vm.hasMoreData)
        XCTAssertNotNil(vm.error.value)
        XCTAssertTrue(vm.error.value?.code == 604)
        XCTAssertEqual(fetchUsersUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak vm] in XCTAssertNil(vm) }
    }
}
