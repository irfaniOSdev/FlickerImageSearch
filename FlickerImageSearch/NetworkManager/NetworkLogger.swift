//
//  NetworkLogger.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 07/05/2022.
//

import UIKit

class NetworkLogger {

    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - Request START - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -Request  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print("NetworkLogger_Request \(logOutput)")
    }
    
    static func log(decodingError: DecodingError?){
        if let error = decodingError {
            switch error {
            case .typeMismatch(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .valueNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .keyNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .dataCorrupted(let key):
                print("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    static func log(error: ErrorHandler?) {
        print("NetworkLogger_Error \(error?.codeError().description ?? "")")
    }
    
    static func log(response: URLResponse?, data: Data){
       
      
        print("\n - - - - - - - - - - Response START - - - - - - - - - - \n")
        let httpResponse = response as? HTTPURLResponse
        print("NetworkLogger_Response \(String(describing: httpResponse))")
        print("\n - - - - - - - - - - Response END- - - - - - - - - - \n")

        print("\n - - - - - - - - - - Response DATA START - - - - - - - - - - \n")
        guard let responseString = String(data: data, encoding: .utf8) else { return }
        print("NetworkLogger_Data \(responseString)")
        print("\n - - - - - - - - - - Response DATA END- - - - - - - - - - \n")
    }
}
