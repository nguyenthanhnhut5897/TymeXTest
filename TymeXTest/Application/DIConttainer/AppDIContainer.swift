//
//  AppDIContainer.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/15.
//

import iOSAPIService

final class AppDIContainer {
    
    lazy var appConfiguration = TymeXTestAPIConfig()
    
    // MARK: - DIContainers of scenes
    func makeHomeIDContainer() -> HomeIDContainer {
        let config = ApiDataConfigurable(baseURL: appConfiguration.apiBaseURL)
        
        let dependencies = HomeIDContainer.ApiDependencies(
            apiDataTransferService: DefaultDataTransferService(config: config)
            // add more api service if any
        )
        return HomeIDContainer(dependencies: dependencies)
    }
}
