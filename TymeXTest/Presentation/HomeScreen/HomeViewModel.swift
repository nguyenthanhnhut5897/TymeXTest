//
//  HomeViewModel.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/14.
//

import iOSAPIService

struct HomeViewModelActions {
    let showUserDetails: (CUser?) -> Void
}

protocol HomeViewModelInput {
    func fetchData(isRefresh: Bool)
    func loadMoreIfNeed()
    func fetchUserProfileData()
}

protocol HomeViewModelOutput {
    var userList: Observable<[CUser]> { get }
    var error: Observable<Error?> { get }
}

final class HomeViewModel: BaseViewModel, HomeViewModelInput, HomeViewModelOutput {
    
    private let userUsecase: UserUseCase
    private let actions: HomeViewModelActions?

    // MARK: - OUTPUT
    var userList: Observable<[CUser]> = Observable([])
    var error: Observable<Error?> = Observable(nil)
    
    init(userUsecase: UserUseCase, actions: HomeViewModelActions?) {
        self.userUsecase = userUsecase
        self.actions = actions
    }
}

extension HomeViewModel {
    func fetchData(isRefresh: Bool = false) {
        if isRefresh {
            page = 0
        }
        
        if !isRefresh, page == 0 {
            LoadingView.show()
        }
        
        let params = GetUserListParams(page: page, perPage: limit)
        
        userUsecase.getUsersList(params: params) { usersCache in
            
        } completion: { [weak self] result in
            guard let self else { return }
            
            LoadingView.hide()
            self.isLoading = false
            
            switch result {
            case .success(let users):
                if isRefresh {
                    self.userList.value = users.unwrapped(or: [])
                } else {
                    self.userList.value.append(contentsOf: users.unwrapped(or: []))
                }
                
                self.hasMoreData = users.unwrapped(or: []).count == self.limit
                self.page += 1
            case .failure(let error):
                self.error.value = error
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMoreIfNeed() {
        guard !isLoading, hasMoreData else { return }
        
        isLoading = true
        fetchData()
    }
    
    func fetchUserProfileData() {
        let params = UserProfileParams(username: "fanvsfan")
        userUsecase.getUserProfile(params: params) { usersCache in
            
        } completion: {  [weak self] result in
            switch result {
            case .success(let user):
                print(user)
            case .failure: break
            }
        }
    }
}
