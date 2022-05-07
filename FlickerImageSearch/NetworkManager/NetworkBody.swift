//
//  NetworkBody.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

class NetworkBody {
    
    // MARK: - Attributes
    private let encoding: EncodingType
    private let parameters: Parameters
    
    // MARK: - Initializers
    init(encoding: EncodingType, parameters: Parameters) {
        self.encoding = encoding
        self.parameters = parameters
    }
    
    // MARK: - Functions
    func getData()-> Data? {
        guard let parameters = parameters else {
            return nil
        }
        switch encoding {
        case .jsonEncoding:
           return try? JSONSerialization.data(withJSONObject:parameters, options: [])
        case .urlEncoding:
            return encodeParameters(parameters: parameters)
        }
    }
    
    private func percentEscapeString(_ string: String) -> String {
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet) ?? string
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    private func encodeParameters(parameters: [String : Any]) -> Data? {
        let converted = parameters.compactMapValues { $0 as? String }
        let parameterArray = converted.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        return parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
