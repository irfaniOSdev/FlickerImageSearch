//
//  Extensions.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

extension URLResponse {
    func statusCode() -> Int? {
        guard let response = self.getHttpURLResponse() else { return nil }
        return response.statusCode
    }
    
    func getHttpURLResponse()-> HTTPURLResponse? {
        guard let response = self as? HTTPURLResponse else { return nil }
        return response
    }
}
