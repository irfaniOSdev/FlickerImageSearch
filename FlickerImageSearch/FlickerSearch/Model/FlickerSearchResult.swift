//
//  FlickerSearchResult.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 07/05/2022.
//

import UIKit

struct FlickerSearchResult: Codable {

    let stat: String?
    let photos: Photos?
}

struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [FlickrPhoto]
    let total: Int
}

struct FlickrPhoto: Codable {
    
    let farm : Int
    let id : String
    
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    
    let owner: String
    let secret : String
    let server : String
    let title: String
}
