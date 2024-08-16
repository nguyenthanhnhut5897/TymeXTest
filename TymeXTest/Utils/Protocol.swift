//
//  Protocol.swift
//  TymeXTest
//
//  Created by Thanh Nhut on 17/8/24.
//

import iOSAPIService

protocol CRepository {}

protocol CUseCase {}

protocol DataTransferService {
    typealias DataTransferHandler<T: Requestable> = (Result<T.Response, DataTransferError>, Data?) -> Void
        
    func send<T: Requestable>(request: T, completion: DataTransferHandler<T>?) -> SessionCancellable?
}
