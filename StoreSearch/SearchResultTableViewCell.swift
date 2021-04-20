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
        nameLabel.text = result.trackName
        artistLabel.text = result.artistName
        
        if let url = URL(string: result.imageSmall), let data = try? Data(contentsOf: url) {
            searchImage.image = UIImage(data: data)
        }
    }

}
