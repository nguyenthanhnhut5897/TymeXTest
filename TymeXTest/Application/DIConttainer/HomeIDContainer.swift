//
//  HomeIDContainer.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/27.
//

import Foundation

final class HomeIDContainer: CBaseDIContainer {
    struct ApiDependencies {
        let apiDataTransferService: DataTransferService
    }
    
    var dependencies: ApiDependencies
    
    // MARK: - Storage
    private var userResponseCache: UserRepositoryCaches = UserRepositoryCachesHandler(maxStorageLimit: 20)
    
    init(dependencies: ApiDependencies) {
        self.dependencies = dependencies
    }
    
    func makeRepository(screenName: CScreenName) -> CRepository? {
        switch screenName {
        case .Home, .UserDetails:
            return UserRepositoryHandler(dataTransferService: dependencies.apiDataTransferService,
                                         cache: userResponseCache)
        default:
            return nil
        }
    }
    
    func makeUseCase(screenName: CScreenName) -> CUseCase? {
        switch screenName {
        case .Home, .UserDetails:
            guard let userRepository = makeRepository(screenName: screenName) as? UserRepository else { return nil }
            
            return UserUseCaseHandler(userRepository: userRepository)
        default:
            return nil
        }
    }
}

extension HomeIDContainer: HomeNavigatorDependencies {
    
    // MARK: Home
    func makeHomeVM(actions: HomeViewModelActions?) -> BaseViewModel? {
        guard let userUsecase = makeUseCase(screenName: .Home) as? UserUseCase else { return nil }
        
        return HomeViewModel(userUsecase: userUsecase, actions: actions)
    }
    
    func makeHomeViewController(actions: HomeViewModelActions?) -> HomeViewController {
        let viewModel = makeHomeVM(actions: actions) as? HomeViewModel
        
        return HomeViewController(viewModel: viewModel)
    }
    
    // MARK: User Details
    func makeUserDetailVM(user: GUser?, actions: UserDetailsModelActions?) -> BaseViewModel? {
        guard let userUsecase = makeUseCase(screenName: .UserDetails) as? UserUseCase else { return nil }
        
        return UserDetailsVM(user: user, userUsecase: userUsecase, actions: actions)
    }
    
    func makeUserDetailViewController(user: GUser?, actions: UserDetailsModelActions?) -> UserDetailsViewController {
        let viewModel = makeUserDetailVM(user: user, actions: actions) as? UserDetailsVM
        
        return UserDetailsViewController(viewModel: viewModel)
    }
}

// MARK: - Flow Coordinators
extension HomeIDContainer {
    func makeHomeNavigator(navigationController: BaseNavigationController) -> HomeNavigator {
        return HomeNavigator(navigationController: navigationController, dependencies: self)
    }
}
