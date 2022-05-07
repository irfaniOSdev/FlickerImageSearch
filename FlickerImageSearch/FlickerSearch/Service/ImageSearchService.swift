//
//  ImageSearchService.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 07/05/2022.
//

import UIKit

class ImageSearchService: NetworkRequestProtocol {
    
    var text: String = ""
    var page: Int = 1
    var requestType: HTTPMethod {
        return .get
    }
    
    var endPoint: String {
        var components = URLComponents()
        components.path = "services/rest/"
        components.queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),URLQueryItem(name: "api_key", value: "\(Constant.apiKey)"), URLQueryItem(name: "text", value: "\(text)"),URLQueryItem(name: "per_page", value: "\(Constant.perPageResult)"),URLQueryItem(name: "page", value: "\(page)"),  URLQueryItem(name: "format", value: "json"), URLQueryItem(name: "nojsoncallback", value: "1")]
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url.absoluteString
    }

}

extension ImageSearchService: ExecuteRequest {
    typealias T = FlickerSearchResult
    func executeRequest(_ completion: @escaping (Result<T, ErrorHandler>, URLResponse?) -> Void) {
        NetworkManager().executeRequest(self, completion: completion)
    }
}
