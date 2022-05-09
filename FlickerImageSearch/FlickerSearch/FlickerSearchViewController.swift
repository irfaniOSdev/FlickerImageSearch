//
//  FlickerSearchViewController.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit
import SwiftSpinner

class FlickerSearchViewController: UIViewController {

    // MARK: - Properties
    let viewModel = FlickerSearchViewModel()
    
    lazy var dataSource: FlickerSearchDataSource = {
        let dataSource = FlickerSearchDataSource(viewModel: viewModel)
        return dataSource
    }()
    
    private var searchBarController: UISearchController!
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        registerListners()
    }
    
    // MARK: - Set up
    func registerListners(){
        viewModel.completion = { [weak self] in
            SwiftSpinner.hide()
            // reload data here
            self?.collectionView.reloadData()
        }
        
        viewModel.failure = { [weak self] error in
            self?.showAlert(message: error)
            print(error)
        }
        
        viewModel.recentSearchAction = { [weak self] recentSearch in
            guard let self = self else { return }
            self.searchBarController.searchBar.text = recentSearch
            self.searchBarController.searchBar.resignFirstResponder()
            self.searchBarController.searchBar.showsCancelButton = true
            SwiftSpinner.show("Searching \(recentSearch)")
            self.viewModel.searchImageRequest(text: recentSearch, page: 1)
        }
    }
    
    func setupSearchBar(){
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.searchBar.placeholder = Constant.StringConstants.searchBarPlaceHolder
        searchBarController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupCollectionView(){
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.register(nib: FlickerImageCollectionViewCell.nibName)
        collectionView.register(nib: RecentSearchCollectionViewCell.nibName)
        collectionView.register(UINib(nibName: FlickerHeaderCollectionReusableView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FlickerHeaderCollectionReusableView.nibName)

    }
}
// MARK: - UISearchBarDelegate
extension FlickerSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.textForSearch = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        collectionView.reloadData()
        SwiftSpinner.show("Searching \(text)")
        viewModel.searchImageRequest(text: text, page: 1)
        searchBarController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.textForSearch = ""
        viewModel.isSearchBarActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        viewModel.photos.removeAll()
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.isSearchBarActive = true
        searchBar.showsCancelButton = true
    }
}

