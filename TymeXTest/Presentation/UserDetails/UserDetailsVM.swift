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
    func fetchData()
}

protocol UserDetailsVMOutput {
    var userInfo: Observable<CUser?> { get }
    var error: Observable<Error?> { get }
}

final class UserDetailsVM: BaseViewModel, UserDetailsVMInput, UserDetailsVMOutput {
    
    private let userUsecase: UserUseCase
    private let actions: UserDetailsModelActions?

    // MARK: - OUTPUT
    var userInfo: Observable<CUser?> = Observable(nil)
    var error: Observable<Error?> = Observable(nil)
    
    init(user: CUser?, userUsecase: UserUseCase, actions: UserDetailsModelActions?) {
        self.userInfo.value = user
        self.userUsecase = userUsecase
        self.actions = actions
    }
}

extension UserDetailsVM {
    func fetchData() {
        guard let username = userInfo.value?.username else {
            userInfo.value = nil
            return
        }
        
        LoadingView.show()
        
        let params = UserProfileParams(username: username)
        
        userUsecase.getUserProfile(params: params) { usersCache in
            
        } completion: {  [weak self] result in
            LoadingView.hide()
            
            switch result {
            case .success(let user):
                self?.userInfo.value = user
                print(user)
            case .failure(let error):
                self?.error.value = error
                print(error.localizedDescription)
            }
        }
    }
}
