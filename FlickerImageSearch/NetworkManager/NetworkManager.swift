//
//  NetworkManager.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

protocol NetworkManagerProtocol {
    func executeRequest<T: Decodable>(_ request: NetworkRequestProtocol, completion: @escaping (Result<T, ErrorHandler>, URLResponse?) -> Void)
}

protocol ExecuteRequest {
    associatedtype T: Decodable
    func executeRequest(_ completion: @escaping (Result<T, ErrorHandler>, URLResponse?) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    let session = URLSession.shared
    func executeRequest<T: Decodable>(_ requestProtocol: NetworkRequestProtocol, completion: @escaping (Result<T, ErrorHandler>, URLResponse?) -> Void) {
        
        if !ConnectionManager.shared.isConnectedToNetwork() {
            NetworkResponse().responseErrorHandling(code: HTTPStatusCode.noConnection, error: nil, completion: completion)
            return
        }
        
        let request = NetworkRequest(request: requestProtocol)
        do {
            try request.buildRequest(onComplete: { (request) in
                switch request {
                case .success(let urlRequest):
                    NetworkLogger.log(request: urlRequest)
                    self.session.dataTask(with: urlRequest) { data, response, error in
                        DispatchQueue.main.async {
                            NetworkResponse().responseHandling(data: data, response: response, error: error, completion: completion)
                        }
                    }.resume()
                case .failure(let error):
                     NetworkLogger.log(error: error)
                    DispatchQueue.main.async {
                        NetworkResponse().responseErrorHandling(error: error, completion: completion)
                    }
                }
            })
        } catch {
            DispatchQueue.main.async {
                NetworkResponse().responseErrorHandling(error: error, completion: completion)
            }
        }
    }
}
