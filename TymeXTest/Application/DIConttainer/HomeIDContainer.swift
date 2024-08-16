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
    
    private var userResponseCache: UserRepositoryCaches = UserRepositoryCachesHandler()
    
    // MARK: - Persistent Storage
    #warning("implement store date to Storage later")
    
    init(dependencies: ApiDependencies) {
        self.dependencies = dependencies
    }
    
    func makeRepository(screenName: CScreenName) -> CRepository? {
        switch screenName {
        case .Home:
            return UserRepositoryHandler(dataTransferService: dependencies.apiDataTransferService)
        default:
            return nil
        }
    }
    
    func makeUseCase(screenName: CScreenName) -> CUseCase? {
        switch screenName {
        case .Home:
            guard let userRepository = makeRepository(screenName: screenName) as? UserRepository else { return nil }
            
            return UserUseCaseHandler(userRepository: userRepository,
                                      userRepositoryCaches: userResponseCache)
        default:
            return nil
        }
    }
    
    func makeViewModel(screenName: CScreenName, actions: HomeViewModelActions?) -> BaseViewModel? {
        switch screenName {
        case .Home:
            guard let userUsecase = makeUseCase(screenName: screenName) as? UserUseCase else { return nil }
            
            return HomeViewModel(userUsecase: userUsecase, actions: actions)
        default:
            return nil
        }
    }
}

extension HomeIDContainer: HomeNavigatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions?) -> HomeViewController {
        let viewModel = makeViewModel(screenName: .Home, actions: actions) as? HomeViewModel
        
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeUserDetailViewController(actions: HomeViewModelActions?) -> HomeViewController {
        let viewModel = makeViewModel(screenName: .Home, actions: actions) as? HomeViewModel
        
        return HomeViewController(viewModel: viewModel)
    }
}

// MARK: - Flow Coordinators
extension HomeIDContainer {
    func makeHomeNavigator(navigationController: BaseNavigationController) -> HomeNavigator {
        return HomeNavigator(navigationController: navigationController,
                      dependencies: self)
    }
}
