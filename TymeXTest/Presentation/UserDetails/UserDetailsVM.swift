//
//  UserDetailsVM.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 18/8/24.
//

enum UserDetailsCellType: Int, CaseIterable {
    case general = 0
    case followerFollowing = 1
    case blog = 2
}

struct UserDetailsModelActions {}

protocol UserDetailsVMInput {
    /// Fetch new data info
    /// - Parameter isRefresh:
    ///    + isRefresh is true -> load data as the first time
    ///    + isRefresh is false -> load more data if any
    func fetchData(isRefresh: Bool)
}

protocol UserDetailsVMOutput {
    var userInfo: Observable<GUser?> { get }
    var error: Observable<Error?> { get }
}

final class UserDetailsVM: BaseViewModel, UserDetailsVMInput, UserDetailsVMOutput {
    
    private let userUsecase: UserUseCase
    private let actions: UserDetailsModelActions?

    // MARK: - OUTPUT
    var userInfo: Observable<GUser?> = Observable(nil)
    var error: Observable<Error?> = Observable(nil)
    
    init(user: GUser?, userUsecase: UserUseCase, actions: UserDetailsModelActions? = nil) {
        self.userInfo.value = user
        self.userUsecase = userUsecase
        self.actions = actions
    }
}

extension UserDetailsVM {
    
    /// Fetch user profile from username
    /// - Parameter isRefresh:
    ///    + isRefresh is true -> do not need show LoadingView
    ///    + isRefresh is false -> show LoadingView
    ///   After finish, the error will be updated in failed case and the userInfo will be updated in success case 
    func fetchData(isRefresh: Bool = false) {
        guard let username = userInfo.value?.username else {
            userInfo.value = nil
            return
        }
        
        if !isRefresh {
            LoadingView.show()
        }
        
        let params = UserProfileParams(username: username)
        
        userUsecase.getUserProfile(params: params) { [weak self] result in
            LoadingView.hide()
            
            switch result {
            case .success(let user):
                self?.userInfo.value = user
            case .failure(let error):
                self?.error.value = error
                print(error.localizedDescription)
            }
        }
    }
}
