//
//  FlickerImageModel.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 08/05/2022.
//

import UIKit

struct FlickerImageModel {

    private let photo: FlickrPhoto
 
    init(photo: FlickrPhoto) {
        self.photo =  photo
    }
    
    func getImageUrl()-> URL? {
        let urlString = String(format: Constant.imageURL, photo.farm, photo.server, photo.id, photo.secret)
        let url = URL(string: urlString)
        return url
    }

}
