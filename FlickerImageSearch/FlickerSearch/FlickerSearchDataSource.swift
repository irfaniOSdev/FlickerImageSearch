//
//  FlickerSearchDataSource.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 09/05/2022.
//

import UIKit

class FlickerSearchDataSource: NSObject {
    weak var viewModel: FlickerSearchViewModel?
    
    init(viewModel: FlickerSearchViewModel?) {
        self.viewModel = viewModel
    }
}

extension FlickerSearchDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        if viewModel.isSearchBarEmptyAndInactive() { return viewModel.getRecentSearches().count }
        else { return viewModel.photos.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell()}
        if viewModel.isSearchBarEmptyAndInactive() {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.nibName, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            cell.title.text = viewModel.getRecentSearches()[indexPath.row]
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickerImageCollectionViewCell.nibName, for: indexPath) as? FlickerImageCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
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
        guard let viewModel = viewModel else { return UICollectionReusableView()}
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FlickerHeaderCollectionReusableView.nibName, for: indexPath) as? FlickerHeaderCollectionReusableView else {         return UICollectionReusableView() }
        let titleString = viewModel.isSearchBarEmptyAndInactive() ? "Recent Searches" : "Photos"
        view.title.text = titleString
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.textForSearch.isEmpty {
            let recentSearch = viewModel.getRecentSearches()[indexPath.row]
            viewModel.recentSearchAction?(recentSearch)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FlickerSearchDataSource: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        if viewModel?.isSearchBarEmptyAndInactive() ?? false {
            return CGSize(width: width, height: 30)
        }
        width -= 30
        return CGSize(width: width/2, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
