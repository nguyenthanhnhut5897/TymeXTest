//
//  AppFlowNavigator.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/15.
//

import UIKit

final class AppFlowNavigator {

    var navigationController: BaseNavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: BaseNavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let homeIDContainer = appDIContainer.makeHomeIDContainer()
        let flow = homeIDContainer.makeHomeNavigator(navigationController: navigationController)
        flow.start()
    }
}
