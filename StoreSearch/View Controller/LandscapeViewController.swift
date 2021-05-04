//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/5/3.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    private let searchCellId = "SearchCollectionCell"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryController: UISegmentedControl!
    @IBOutlet weak var messageLabel: UILabel!
    

    lazy var search = SearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register cell
        let cell = UINib(nibName: "SearchCollectionCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: searchCellId)
        
        configureView()
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        searchResult()
    }
    
    private func configureView() {
        collectionView.reloadData()
        configureMessageLabel()
        configureActivityIndicator()
        
        if search.status == .notSearchedYet {
            searchBar.becomeFirstResponder()
        }
        else {
            searchBar.resignFirstResponder()
        }
    }
    
    private func configureMessageLabel() {
        switch search.status {
        case .notSearchedYet:
            messageLabel.text = "Please Input Search Item"
        case .noResult:
            messageLabel.text = "Nothing Found"
        case .searching:
            messageLabel.text = "Loading..."
        default:
            messageLabel.text = ""
        }
    }
    
    private func configureActivityIndicator() {
        activityIndicator.isHidden = search.status != .searching
        
        if activityIndicator.isHidden {
            activityIndicator.stopAnimating()
        }
        else {
            activityIndicator.startAnimating()
        }
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LandscapeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.resultsNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as? SearchCollectionViewCell
                
        if let result = search.getResult(by: indexPath.item) {
            cell?.configure(with: result)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let result = search.getResult(by: indexPath.item) {
            print("select Item: \(indexPath.item), name: \(result.name)")
        }
    }
}

extension LandscapeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResult()
    }
    
    private func showNetworkError() {
        let alertController = UIAlertController(title: "Woops...", message: "There was an error accessing the iTunes Store. Please Try Again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func getCategory() -> Category {
        let selectedTitle = categoryController.titleForSegment(at: categoryController.selectedSegmentIndex)
        return Category(rawValue: selectedTitle ?? "All") ?? .all
    }

    
    private func searchResult() {
        search.performSearch(with: searchBar.text!, for: getCategory()) { [weak self] status in
            self?.configureView()
            
            if status == .networkError {
                self?.showNetworkError()
            }
        }
        
        configureView()
    }
}


