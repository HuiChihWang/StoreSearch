//
//  ViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let search = SearchModel()
    
    private let searchCellId = "SearchResultCell"
    private let nothingFoundCellId = "NothingFoundCell"
    private let loadingCellId = "LoadingCell"
    private let goToDetailViewSequeID = "ShowDetail"
    
    private let landscapeStoryboardName = "LandscapeView"
    private let landscapeControllerId = "SearchViewLandscape"
    
    private var landscapeView: LandscapeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewCell()

        searchBar.becomeFirstResponder()
        
        // TODO: fix force display lanscapeview
//        showLanscapeView()
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            showLanscapeView()
        }
        else {
            hideLanscapeView()
            landscapeView = nil
        }
    }
    
    private func showLanscapeView() {
        let storyboard = UIStoryboard(name: landscapeStoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: landscapeControllerId)
        landscapeView = controller as? LandscapeViewController
        
        if let landscapeView = landscapeView {
            landscapeView.search = search
            addChild(landscapeView)
            landscapeView.view.frame = view.frame
            self.view.addSubview(landscapeView.view)
            landscapeView.didMove(toParent: self)
        }
        
        searchBar.resignFirstResponder()

    }
    
    private func hideLanscapeView() {
        landscapeView?.willMove(toParent: nil)
        landscapeView?.view.removeFromSuperview()
        landscapeView?.removeFromParent()
        searchBar.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == goToDetailViewSequeID) {
            if let controller = segue.destination as? DetailViewController {
                controller.result = sender as? SearchResult
            }
        }
        
        else if segue.identifier == "rotateView" {
            if let controller = segue.destination as? LandscapeViewController {
                controller.search = search
            }
        }
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
            performSegue(withIdentifier: goToDetailViewSequeID, sender: result)
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
    
    private func setupTableViewCell() {
        let resultCell = UINib(nibName: "SearchResultCell", bundle: nil)
        let nothingFoundCell = UINib(nibName: "NothingFoundCell", bundle: nil)
        let loadingCell = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(resultCell, forCellReuseIdentifier: searchCellId)
        tableView.register(nothingFoundCell, forCellReuseIdentifier: nothingFoundCellId)
        tableView.register(loadingCell, forCellReuseIdentifier: loadingCellId)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        performSearch()
    }
    
    private func getCategory() -> Category {
        let selectedTitle = categoryControl.titleForSegment(at: categoryControl.selectedSegmentIndex)
        
        return Category(rawValue: selectedTitle ?? "All") ?? .all
    }
        
    private func performSearch() {
        searchBar.resignFirstResponder()
        

        
        search.performSearch(with: searchBar.text!, for: getCategory()) { status in
            if (status == .networkError) {
                self.showNetworkError()
            }
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }

    
    private func showNetworkError() {
        let alertController = UIAlertController(title: "Woops...", message: "There was an error accessing the iTunes Store. Please Try Again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


