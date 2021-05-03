//
//  SearchCollectionViewCell.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/5/3.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 5
            imageView.layer.cornerRadius = 10
        }
    }
    
    
    private var downloadTask: URLSessionDownloadTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(with result: SearchResult) {
        if let imageURL = result.imageSmall, let requestURL = URL(string: imageURL) {
            downloadTask = imageView.downloadImage(with: requestURL)
        }
    }
}
