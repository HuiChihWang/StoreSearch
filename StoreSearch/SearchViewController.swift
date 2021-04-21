//
//  ViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let search = SearchModel()
    
    private let searchCellId = "SearchResultCell"
    private let nothingFoundCellId = "NothingFoundCell"
    private let loadingCellId = "LoadingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let resultCell = UINib(nibName: "SearchResultCell", bundle: nil)
        let nothingFoundCell = UINib(nibName: "NothingFoundCell", bundle: nil)
        let loadingCell = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: searchCellId)
        tableView.register(nothingFoundCell, forCellReuseIdentifier: nothingFoundCellId)
        tableView.register(loadingCell, forCellReuseIdentifier: loadingCellId)
        
        searchBar.becomeFirstResponder()
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (search.status == .noResult || search.status == .searching) {
            return 1
        }
        
        return search.resultsNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        var cell: UITableViewCell!
        
        if (search.status == .hasSearchResult) {
            if let detailCell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as? SearchResultTableViewCell {
                let result = search.getResult(by: indexPath.row) ?? SearchResult()
                detailCell.configureCell(with: result)
                
                cell = detailCell
            }
        }
        else if (search.status == .searching) {
            if let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as? LoadingTableViewCell {
                loadingCell.activityIndicator.startAnimating()
                cell = loadingCell
            }
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: nothingFoundCellId, for: indexPath)
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let result = search.getResult(by: indexPath.row) {
            print(result)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if (search.status == .hasSearchResult) {
            return indexPath
        }
        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        search.setUpSearchText(with: searchBar.text!)
        tableView.reloadData()
        searchBar.resignFirstResponder()
        
        DispatchQueue.global().async {
            self.search.startSearch()
            
            DispatchQueue.main.async {
                
                if (self.search.status == .networkError) {
                    self.showNetworkError()
                }

                self.tableView.reloadData()
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
    
    private func showNetworkError() {
        let alertController = UIAlertController(title: "Woops...", message: "There was an error accessing the iTunes Store. Please Try Again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


