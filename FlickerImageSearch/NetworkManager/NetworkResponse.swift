//
//  NetworkResponse.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

class NetworkResponse {

    func responseHandling<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion:(Result<T, ErrorHandler>, URLResponse? ) -> Void) {
        do {
            if let error = error {
                self.responseErrorHandling(error: error, completion: completion)
                return
            }
            guard let data = data else {
                self.responseErrorHandling(code: HTTPStatusCode(rawValue: response?.statusCode() ?? 0), error: error, completion: completion)
                return
            }
            NetworkLogger.log(response: response, data: data)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedObject), response)
        }
        catch {
            let decodingError = error as? DecodingError
            NetworkLogger.log(decodingError: decodingError)
            completion(.failure(.error(code: HTTPStatusCode(rawValue: response?.statusCode() ?? 0), error: error, data: data)), nil)
        }
    }
    
    func responseErrorHandling<T: Decodable>(code: HTTPStatusCode? = nil, error: Error?, completion:(Result<T, ErrorHandler>, URLResponse? ) -> Void){
        completion(.failure(.error(code: code, error: error, data: nil)), nil)
    }

}
