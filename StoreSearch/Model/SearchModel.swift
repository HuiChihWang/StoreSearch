//
//  SearchModel.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/21.
//

import Foundation

class SearchModel {
    private var results = SearchResults() {
        didSet {
            results.results.sort(by: <)
        }
    }
    
    var resultsNum: Int {
        results.resultCount
    }
    
    var allResults: [SearchResult] {
        results.results
    }
    
    private(set) var status = SearchStatus.notSearchedYet
    
    var isEmpty: Bool {
        status == .noResult
    }
    
    private var searchURL: URL? {
        didSet {
            status = .searching
        }
    }
    
    // TODO: need to use asynchronous programming (URL Session)
    public func setUpSearchText(with text: String, by category: Category = .all, number: Int = 50) {
        if let searchText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let urlString = String(format: "https://itunes.apple.com/search?term=%@&type=%@&limit=%d", searchText, category.searchKey, number)
            
            searchURL = URL(string: urlString)
            print("searching with url: \(searchURL!)")
        }
    }
    
    
    public func startSearch() {
        if let searchURL = searchURL, let data = self.persormSearchRequest(with: searchURL) {
            results = parse(data: data)
            status = results.isEmpty ? .noResult : .hasSearchResult
        }
    }

    
    public func getResult(by index: Int) -> SearchResult? {
        results.getResult(by: index)
    }
    

    
    private func persormSearchRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            self.status = .networkError
        }
        
        return nil
    }
    
    private func parse(data: Data) -> SearchResults {
        var result = SearchResults()
        
        do {
            let decoder = JSONDecoder()
            result = try decoder.decode(SearchResults.self, from: data)
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
        }
        
        return result
    }
}

enum SearchStatus {
    case notSearchedYet
    case hasSearchResult
    case noResult
    case searching
    case networkError
}

enum Category: String {
    case all = "All"
    case music = "Music"
    case software = "Software"
    case ebook = "E-books"
    
    var searchKey: String {
        switch self {
        case .music:
            return "musicTrack"
        case .software:
            return "software"
        case .ebook:
            return "ebook"
        default:
            return ""
        }
    }
}