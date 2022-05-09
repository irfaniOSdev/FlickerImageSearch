//
//  ConnectionManager.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 10/05/2022.
//

import UIKit
import Reachability
class ConnectionManager: NSObject {
    
    static let shared = ConnectionManager()
    private override init () {}
    
    func isConnectedToNetwork() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            case .none:
                return false
            }
        }
        catch {
            return false
        }
    }
}
