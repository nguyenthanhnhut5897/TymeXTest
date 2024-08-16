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
    func fetchData()
    func fetchUserProfileData()
}

protocol HomeViewModelOutput {
    var title: Observable<String?> { get }
}

final class HomeViewModel: BaseViewModel, HomeViewModelInput, HomeViewModelOutput {
    
    private let userUsecase: UserUseCase
    private let actions: HomeViewModelActions?

    // MARK: - OUTPUT
    var title: Observable<String?> = Observable(nil)
    
    init(userUsecase: UserUseCase, actions: HomeViewModelActions?) {
        self.title.value = "Home"
        self.userUsecase = userUsecase
        self.actions = actions
    }
}

extension HomeViewModel {
    func fetchData() {
        let params = GetUserListParams(page: 0, perPage: 20)
        
        userUsecase.getUsersList(params: params) { usersCache in
            
        } completion: { [weak self] result in
            switch result {
            case .success(let users):
                self?.title.value = users?.first?.username
            case .failure: break
            }
        }
    }
    
    func fetchUserProfileData() {
        let params = UserProfileParams(username: "fanvsfan")
        userUsecase.getUserProfile(params: params) { usersCache in
            
        } completion: {  [weak self] result in
            switch result {
            case .success(let user):
                self?.title.value = user?.username
            case .failure: break
            }
        }
    }
}
