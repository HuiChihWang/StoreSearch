//
//  SearchResultTableViewCell.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    {
        didSet {
            searchImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    
    private var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectedBackgroundView = UIView(frame: self.frame)
        selectedBackgroundView?.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configureCell(with result: SearchResult) {
        nameLabel.text = result.name
        artistLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        
        if let imageURL = result.imageSmall, let requestURL = URL(string: imageURL) {
//            prepareImageView(with: requestURL)
            downloadTask = searchImage.downloadImage(with: requestURL)
            
        }
    }
    
    
    
    private func prepareImageView(with imageURL: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
                
                // weak self: check whether current object is still alive
                DispatchQueue.main.async { [weak self] in
                    if let weakSelf = self {
                        weakSelf.searchImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}

extension UIImageView {
    func downloadImage(with url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        
        let task = session.downloadTask(with: url) { [weak self] url, res, error in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        
        task.resume()
        return task
    }
}
