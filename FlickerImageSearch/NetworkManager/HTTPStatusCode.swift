//
//  HTTPStatusCode.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

enum HTTPStatusCode: Int {

    case success = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case invalidURL
    case requestTimeout
    case internalServerError = 500
    case noConnection = 1009
    
    public var description: String {
        switch self {
        case .internalServerError:
            return ""
        case .noConnection:
            return ""
        default:
            return "Error with code: \(self.rawValue)"
        }
    }
}

