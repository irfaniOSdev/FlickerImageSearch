//
//  Extensions.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit
// MARK: - URLResponse
extension URLResponse {
    func statusCode() -> Int? {
        guard let response = self.getHttpURLResponse() else { return nil }
        return response.statusCode
    }
    
    func getHttpURLResponse()-> HTTPURLResponse? {
        guard let response = self as? HTTPURLResponse else { return nil }
        return response
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    func register(nib nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}

// MARK: - UIViewController
extension UIViewController {
    func showAlert(title: String = "Alert", message: String, viewController:UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
