//
//  FlickerSearchViewController.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

class FlickerSearchViewController: UIViewController {

    // MARK: - Properties
    let viewModel = FlickerSearchViewModel()
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
            // reload data here
            self?.collectionView.reloadData()
        }
        
        viewModel.failure = { [weak self] error in
            self?.showAlert(message: error)
            print(error)
        }
    }
    
    func setupSearchBar(){
        searchBarController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBarController
        searchBarController.searchBar.placeholder = "Search here"
        searchBarController.searchBar.delegate = self
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib: FlickerImageCollectionViewCell.nibName)
        collectionView.register(nib: RecentSearchCollectionViewCell.nibName)
        collectionView.register(UINib(nibName: FlickerHeaderCollectionReusableView.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FlickerHeaderCollectionReusableView.nibName)

    }
}
// MARK: - UISearchBarDelegate
extension FlickerSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        collectionView.reloadData()
        viewModel.searchImageRequest(text: text, page: 1)
        searchBarController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        viewModel.photos.removeAll()
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func isSearchBarEmptyAndInactive()-> Bool {
        return searchBarController.searchBar.text?.isEmpty ?? false && !searchBarController.isActive
    }
    
    func isSearchBarEmpty()-> Bool {
        return searchBarController.searchBar.text?.isEmpty ?? false
    }
}
// MARK: - UICollectionViewDataSource
extension FlickerSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchBarEmptyAndInactive() { return viewModel.getRecentSearches().count }
        else { return viewModel.photos.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearchBarEmptyAndInactive() {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.nibName, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            cell.title.text = viewModel.getRecentSearches()[indexPath.row]
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickerImageCollectionViewCell.nibName, for: indexPath) as? FlickerImageCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FlickerImageCollectionViewCell else {
            return
        }
        let model = viewModel.getFlickerImageModel(row: indexPath.row)
        cell.configureCell(model: model)
        
        if indexPath.row == (viewModel.photos.count - 10) {
            viewModel.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FlickerHeaderCollectionReusableView.nibName, for: indexPath) as? FlickerHeaderCollectionReusableView else {         return UICollectionReusableView() }
        let titleString = isSearchBarEmptyAndInactive() ? "Recent Searches" : "Photos"
        view.title.text = titleString
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchBarEmpty() {
            let recentSearch = viewModel.getRecentSearches()[indexPath.row]
            searchBarController.searchBar.text = recentSearch
            searchBarController.searchBar.resignFirstResponder()
            searchBarController.searchBar.showsCancelButton = true
            viewModel.searchImageRequest(text: recentSearch, page: 1)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FlickerSearchViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        if isSearchBarEmptyAndInactive() {
            return CGSize(width: width, height: 30)
        }
        width -= 30
        return CGSize(width: width/2, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
