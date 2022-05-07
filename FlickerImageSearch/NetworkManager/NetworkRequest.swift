//
//  NetworkRequest.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

typealias Parameters = [String : Any]?
typealias Headers = [String : String]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

enum EncodingType {
    case jsonEncoding
    case urlEncoding
}

enum ContentType: String {
    case application
    case form
}

protocol NetworkRequestProtocol {
    var baseURL: String              { get }
    var requestType: HTTPMethod      { get }
    var endPoint: String             { get }
    var parameters: Parameters       { get }
    var headers: Headers             { get }
    var contentType: ContentType     { get }
    var encoding: EncodingType       { get }
    var body: NetworkBody            { get }
}

extension NetworkRequestProtocol {
    
    var baseURL: String {
        return NetworkEnvironment.production.baseURL
    }
       
    var absoluteURL: String {
        return "\(baseURL)\(endPoint)"
    }
    
    var contentType: ContentType {
        return .application
    }
    
    var encoding: EncodingType {
        return .jsonEncoding
    }
    
    var headers: Headers {
        return  contentType == .application ? ["Content-Type": "application/json"] : ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    var parameters: Parameters {
        return nil
    }
    
    var body: NetworkBody {
        return NetworkBody(encoding: encoding, parameters: parameters)
    }
}

class NetworkRequest {
    
    var request: NetworkRequestProtocol
    
    init(request: NetworkRequestProtocol) {
        self.request = request
    }
    
    func buildRequest(onComplete: @escaping (Result<URLRequest, ErrorHandler>) -> Void) throws{
        if let url = URL(string: request.absoluteURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod          = request.requestType.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            if let body = request.body.getData() {
                urlRequest.httpBody = body
            }
            onComplete(.success(urlRequest))
        }else {
            onComplete(.failure(.error(code: HTTPStatusCode.invalidURL, error: nil, data: nil)))
        }
    }
}
