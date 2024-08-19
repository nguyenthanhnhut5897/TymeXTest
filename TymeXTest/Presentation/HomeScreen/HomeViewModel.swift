//
//  HomeViewModel.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/14.
//

struct HomeViewModelActions {
    let showUserDetails: (GUser?) -> Void
}

protocol HomeViewModelInput {
    /// Fetch new data info
    /// - Parameter isRefresh:
    ///    + isRefresh is true -> load data as the first time
    ///    + isRefresh is false -> load more data if any
    func fetchData(isRefresh: Bool)
    
    /// Load more data if any
    func loadMoreIfNeed()
    
    /// User has selected an item
    /// - Parameter index: index of the item
    func didSelectItem(at index: Int)
}

protocol HomeViewModelOutput {
    var userList: Observable<[GUser]> { get }
    var error: Observable<Error?> { get }
}

final class HomeViewModel: BaseViewModel, HomeViewModelInput, HomeViewModelOutput {
    
    private let userUsecase: UserUseCase
    private let actions: HomeViewModelActions?

    // MARK: - OUTPUT
    var userList: Observable<[GUser]> = Observable([])
    var error: Observable<Error?> = Observable(nil)
    
    init(userUsecase: UserUseCase, actions: HomeViewModelActions? = nil) {
        self.userUsecase = userUsecase
        self.actions = actions
    }
}

extension HomeViewModel {
    
    /// Fetch new user list base on page index
    /// - Parameter isRefresh:
    ///    + isRefresh is true -> reset page index to 0 and do not need show LoadingView
    ///    + isRefresh is false -> fetch user list with page index and show LoadingView
    ///   After finish, the error will be updated in failed case and the userList will be updated in success case
    func fetchData(isRefresh: Bool = false) {
        if isRefresh {
            page = 0
        }
        
        if !isRefresh, page == 0 {
            LoadingView.show()
        }
        
        let params = GetUserListParams(page: page, perPage: limit)
        var hasDataCache: Bool = false
        self.error.value = nil
        
        userUsecase.getUsersList(params: params) { [weak self] usersCache in
            guard let self else { return }
            LoadingView.hide()
            self.userList.value = usersCache.unwrapped(or: [])
            hasDataCache = true
            
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
                if hasDataCache {
                    self.page += 1
                }
                
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
    
    func didSelectItem(at index: Int) {
        actions?.showUserDetails(userList.value[safe: index])
    }
}
