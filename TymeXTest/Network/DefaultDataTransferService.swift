//
//  DefaultDataTransferService.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import iOSAPIService

// where use ApiService only

final class DefaultDataTransferService: DataTransferService {
    private let config: ApiDataConfigurable
    
    init(config: ApiDataConfigurable) {
        self.config = config
    }
    
    func send<T>(request: T, completion: DataTransferHandler<T>?) -> SessionCancellable? where T : Requestable {
        return ApiService.shared.send(with: request, config: config) { result, rawData in
            completion?(result, rawData)
        }
    }
}
