//
//  DefaultDataTransferService.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import iOSAPIService

/// Where use ApiService only
/// config: that info is used to call api (baseurl, timeout, retryCount, ..)
final class DefaultDataTransferService: DataTransferService {
    private let config: ApiDataConfigurable
    
    init(config: ApiDataConfigurable) {
        self.config = config
    }
    
    /// Use ApiService to send a request to server and receive a response
    /// - Parameters:
    ///   - request: a Requestable, that contain request info such as  path, query params, data, method, ...
    ///   - completion: return result and raw data
    /// - Returns: return the request task, it is SessionCancellable, we can call cancel() func to cancel request intermediary
    func send<T>(request: T, completion: DataTransferHandler<T>?) -> SessionCancellable? where T : Requestable {
        return ApiService.shared.send(with: request, config: config) { result, rawData in
            completion?(result, rawData)
        }
    }
}
