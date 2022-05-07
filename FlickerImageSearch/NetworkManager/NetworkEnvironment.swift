//
//  NetworkEnvironment.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

enum NetworkEnvironment: String, CaseIterable {
    case production
}
// MARK: - Extension
extension NetworkEnvironment {
        
    var baseURL: String {
        switch self {
        case .production:
            return "https://www.flickr.com/"
        }
    }
}
