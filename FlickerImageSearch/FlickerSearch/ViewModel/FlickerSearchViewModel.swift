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
    var photos = [FlickrPhoto]()
    var textForSearch = ""
    private var pageNo = 1
    private var totalPages = 1
    var isSearchBarActive = false
    var completion : (()->())?
    var failure    : ((String)->())?
    var recentSearchAction : ((String)->())?
    private var recentsSearches: [String] = [String]() {
        didSet {
            UserDefaults.standard.set(recentsSearches, forKey: Constant.UserDefaultKeys.recentSearches)
            UserDefaults.standard.synchronize()
        }
    }
    // MARK: - Init
    init() {
        if let array = UserDefaults.standard.object(forKey: Constant.UserDefaultKeys.recentSearches) as? [String] {
            recentsSearches = array
        }
    }
    // MARK: - Functions
    func searchImageRequest(text: String, page: Int){
        if page == 1 { photos.removeAll() }
        if text.isEmpty { return }
        setRecentSearchText(text: text)
        textForSearch = text
        sendRequest()
    }
    
    private func sendRequest(){
        service.text = textForSearch
        service.page = pageNo
        service.executeRequest { [weak self] result, _ in
            switch result {
            case .success(let model):
                if let photosModel = model.photos {
                    self?.totalPages = photosModel.total ?? 0
                    guard let photos = photosModel.photo else {
                        self?.failure?(model.stat ?? Constant.StringConstants.generalErrorMessage)
                        return
                    }
                    self?.photos.append(contentsOf: photos)
                    self?.completion?()
                }else{
                    self?.failure?(model.stat ?? Constant.StringConstants.generalErrorMessage)
                }
            case .failure(let error):
                self?.failure?(error.codeError().description ?? Constant.StringConstants.generalErrorMessage)
            }
        }
    }
    
    func isSearchBarEmptyAndInactive()-> Bool {
        return !isSearchBarActive && textForSearch.isEmpty
    }
    
    func getRecentSearches()-> [String] {
        if let array = UserDefaults.standard.object(forKey: Constant.UserDefaultKeys.recentSearches) as? [String] {
            recentsSearches = array
        }
        return recentsSearches
    }
    
    func setRecentSearchText(text: String) {
        if !recentsSearches.contains(text) {
            recentsSearches.insert(text, at: 0)
        }
    }
    
    func getFlickerImageModel(row: Int)-> FlickerImageModel? {
        return FlickerImageModel(photo: photos[row])
    }
    
    func fetchNextPage() {
        if pageNo < totalPages {
            pageNo += 1
            searchImageRequest(text: textForSearch, page: pageNo)
        } else {
            completion?()
        }
    }
}
