//
//  SearchModel.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/21.
//

import Foundation

typealias SearchCompleteHandler = (SearchStatus) -> Void

class SearchModel {
    var resultsNum: Int {
        results.resultCount
    }
    
    var allResults: [SearchResult] {
        results.results
    }
    
    var isEmpty: Bool {
        status == .noResult
    }
    
    private(set) var status = SearchStatus.notSearchedYet
    
    private var searchURL: URL? {
        didSet {
            status = .searching
        }
    }
    
    private var results = SearchResults() {
        didSet {
            results.results.sort(by: <)
        }
    }
    
    private var dataTask: URLSessionDataTask?
    
    public func performSearch(with text: String, for category: Category, number: Int = 50, completion: @escaping SearchCompleteHandler) {
        
        initializeSearch(with: text, by: category, number: number)
        
        guard !text.isEmpty else {
            status = .notSearchedYet
            return
        }
        
        if let url = searchURL {
            self.dataTask = self.createDataTask(with: url, completion: completion)
        }
        
        dataTask?.resume()
    }
    
    private func initializeSearch(with text: String, by category: Category, number: Int = 50) {
        if let searchText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = String(format: "https://itunes.apple.com/search?term=%@&media=%@&limit=%d", searchText, category.searchKey, number)
            
            searchURL = URL(string: urlString)
            print("searching with url: \(searchURL!)")
        }
        
        results = SearchResults()
        dataTask?.cancel()
    }
    
    private func createDataTask(with url: URL, completion: @escaping SearchCompleteHandler) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                self.results = self.parse(data: data)
                self.status = self.results.isEmpty ? .noResult : .hasSearchResult
            }
            if let error = error {
                print("Download Error: \(error.localizedDescription)")
                self.status = .networkError
            }
            
            DispatchQueue.main.async {
                completion(self.status)
            }
        }
        
        return dataTask
    }

    
    public func getResult(by index: Int) -> SearchResult? {
        results.getResult(by: index)
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
            return "music"
        case .software:
            return "software"
        case .ebook:
            return "ebook"
        default:
            return ""
        }
    }
}
