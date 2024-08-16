//
//  CBaseDIContainer.swift
//  TymeXTest
//
//  Created by Nguyen Thanh Nhut on 2023/04/27.
//

import Foundation

protocol CBaseDIContainer {
    associatedtype Dependencies
    
    var dependencies: Dependencies { get }
    
    // MARK: - Repositories
    func makeRepository(screenName: CScreenName) -> CRepository?
    
    // MARK: - Use Cases
    func makeUseCase(screenName: CScreenName) -> CUseCase?
    
    // MARK: - View Model
    func makeViewModel(screenName: CScreenName, actions: HomeViewModelActions?) -> BaseViewModel?
}
