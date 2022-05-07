//
//  ViewController.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 06/05/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    let viewModel = FlickerSearchViewModel()
    
    // MARK: - IBOutlets
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerListners()
    }
    
    // MARK: - Set up
    func registerListners(){
        viewModel.completion = {
            // TODO: - reload data here
        }
        
        viewModel.failure = { error, statusCode in
            print(error)
            print(statusCode)
        }
    }
}

