//
//  LandscapeDetailViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/5/4.
//

import UIKit

class LandscapeDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    @IBOutlet weak var priceBorder: UIView! {
        didSet {
            priceBorder.layer.cornerRadius = 5
            priceBorder.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
            priceBorder.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var popUpView: UIView!
    {
        didSet {
            popUpView.layer.cornerRadius = 10
            popUpView.layer.borderWidth = 5
        }
    }
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
        }
    }

    
    
    private var downloadTask: URLSessionDownloadTask?
    
    private var priceString: String {
        var priceText = "FREE"
        
        if result.price != 0.0, let priceString = priceFormatter.string(from: result.price as NSNumber) {
            priceText = priceString
        }
        
        return priceText
    }
    
    private lazy var priceFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = result.currency
        return formatter
    }()

    var result = SearchResult()
    
    deinit {
        downloadTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetail()
    }
    
    func configureDetail() {
        nameLabel.text = result.name
        artistLabel.text = result.artist
        typeLabel.text = result.type
        genreLabel.text = result.genre
        priceButton.setTitle(priceString, for: .normal)
        
        if let url = URL(string: result.imageLarge ?? "") {
            downloadTask = imageView.downloadImage(with: url)
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInStore(_ sender: Any) {
        if let storeUrl = URL(string: result.storeURL) {
            UIApplication.shared.open(storeUrl, options: [:], completionHandler: nil)
        }
    }

    

}
