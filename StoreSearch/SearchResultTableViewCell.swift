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
    
    func configureCell(with result: SearchResult) {
        nameLabel.text = result.name
        artistLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        
        if let imageURL = result.imageSmall, let requestURL = URL(string: imageURL) {
            if let data = try? Data(contentsOf: requestURL) {
                searchImage.image = UIImage(data: data)
            }
        }
    }

}
