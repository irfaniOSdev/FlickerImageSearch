//
//  ErrorHandler.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

enum ErrorHandler: Error {
    
    case error(code: HTTPStatusCode?, error: Error?, data: Data?)
    func codeError() -> (code: HTTPStatusCode?, description: String?) {
        switch self {
        case .error(let code, let error, _):
            if let description = code?.description {
                return (code, description)
            }else{
                return (code, error?.localizedDescription)
            }
        }
    }
}


