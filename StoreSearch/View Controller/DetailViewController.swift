//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/22.
//

import UIKit

class DetailViewController: UIViewController {
    var result: SearchResult?
    
    @IBOutlet weak var popUpView: UIView!
    {
        didSet {
            popUpView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var detailImage: UIImageView!
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
    
    deinit {
        print("destroy view")
        imageTask?.cancel()
    }
    
    private var imageTask: URLSessionDownloadTask?
    
    private lazy var priceFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = result?.currency
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePopUp()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func openInStore(_ sender: Any) {
        if let strUrl = result?.storeURL, let storeUrl = URL(string: strUrl) {
            UIApplication.shared.open(storeUrl, options: [:], completionHandler: nil)
        }
    }
    
    private func configurePopUp() {
        nameLabel.text = result?.name
        artistLabel.text = result?.artist
        typeLabel.text = result?.type
        genreLabel.text = result?.genre
        
        if let price = result?.price {
            priceButton.setTitle(getPriceString(with: price), for: .normal)
        }
        
        
        if let strURL = result?.imageLarge, let imageURL = URL(string: strURL) {
            imageTask = detailImage.downloadImage(with: imageURL)
        }
    }
    
    private func getPriceString(with price: Double) -> String {
        var priceText = "FREE"
        
        if price != 0.0, let priceString = priceFormatter.string(from: price as NSNumber) {
            priceText = priceString
        }
        
        return priceText
    }
}
