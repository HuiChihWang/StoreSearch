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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let resultCell = UINib(nibName: "SearchResultCell", bundle: nil)
        let nothingFoundCell = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: searchCellId)
        tableView.register(nothingFoundCell, forCellReuseIdentifier: nothingFoundCellId)
        
        searchBar.becomeFirstResponder()
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (search.status == .noResult) {
            return 1
        }
        
        return search.resultsNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        var cell: UITableViewCell!
        
        if (search.status == .hasSearchResult) {
            if let extraCell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath) as? SearchResultTableViewCell {
                let result = search.getResult(by: indexPath.row) ?? SearchResult()
                extraCell.nameLabel.text = result.name
                extraCell.artistLabel.text = result.artistName
                
                cell = extraCell
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return search.status == .hasSearchResult ? indexPath : nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("The search text is: '\(searchBar.text!)'")
        
        search.search(with: searchBar.text!)
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}


