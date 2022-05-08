//
//  FlickerImageCollectionViewCell.swift
//  FlickerImageSearch
//
//  Created by Muhammad Irfan on 08/05/2022.
//

import UIKit
import Kingfisher
class FlickerImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Attributes
    static let nibName = "FlickerImageCollectionViewCell"
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configureCell(model: FlickerImageModel?) {
        if let model = model {
            imageView.kf.setImage(with: model.getImageUrl())
        }
    }
}
