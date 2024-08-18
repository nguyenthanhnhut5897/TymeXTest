//
//  RepositoryTask.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 7/5/24.
//  Copyright © 2024 Thanh Nhut. All rights reserved.
//

import iOSAPIService

protocol TaskCancellable {
    func cancel()
}

class RepositoryTask: TaskCancellable {
    var networkTask: SessionCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
