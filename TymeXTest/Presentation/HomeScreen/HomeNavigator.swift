//
//  HomeNavigator.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/15.
//

import UIKit

protocol HomeNavigatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions?) -> HomeViewController
    func makeUserDetailViewController(user: CUser?, actions: UserDetailsModelActions?) -> UserDetailsViewController
}

final class HomeNavigator {
    
    private let navigationController: BaseNavigationController?
    private let dependencies: HomeNavigatorDependencies

    init(navigationController: BaseNavigationController,
         dependencies: HomeNavigatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showUserDetails: showUserDetails)
        let vc = dependencies.makeHomeViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showUserDetails(user: CUser?) {
        let vc = dependencies.makeUserDetailViewController(user: user, actions: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
