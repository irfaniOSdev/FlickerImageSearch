//
//  Constant.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 07/05/2022.
//

import UIKit

class Constant {

    static let apiKey = "a4f28588b57387edc18282228da39744"
    static let perPageResult =  50
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@.jpg"
    
    enum UserDefaultKeys {
        static let recentSearches = "RecentSearches"
    }

    enum StringConstants {
        static let searchBarPlaceHolder = "Search here"
        static let generalErrorMessage = "No result found"
        static let somethingWentWrong = "Something went wrong"
        static let internetCheck = "Please check your internet"
    }
}
