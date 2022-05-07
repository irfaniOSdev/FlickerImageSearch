//
//  FlickerSearchViewModel.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 07/05/2022.
//

import UIKit

class FlickerSearchViewModel {
    
    // MARK: - Attributes
    private let service = ImageSearchService()
    private var searchResult: FlickerSearchResult?
    var completion : (()->())?
    var failure    : ((String, Int)->())?

    // MARK: - Functions
    func searchImageRequest(text: String, page: Int){
        service.text = text
        service.page = page
        service.executeRequest { [weak self] result, _ in
            switch result {
            case .success(let model):
                self?.searchResult = model
                self?.completion?()
            case .failure(let error):
                self?.failure?(error.codeError().description ?? "", error.codeError().code?.rawValue ?? 0)
            }
        }
    }
}
