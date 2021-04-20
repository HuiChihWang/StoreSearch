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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
                
        let result = search.getResult(by: indexPath.row) ?? SearchResult()
        cell.textLabel?.text = result.name
        cell.detailTextLabel?.text = result.artistName
        
        if (search.status == .noResult) {
            cell.textLabel?.text = "(Nothing Found)"
            cell.detailTextLabel?.text = ""
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


