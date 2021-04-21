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
    
    private(set) var status = SearchStatus.notSearchedYet
    
    var isEmpty: Bool {
        status == .noResult
    }
    
    // TODO: need to use asynchronous programming
    public func search(with text: String) {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let searchText = encodedText, let requestURL = getiTuneURL(with: searchText) {
            print("searching with text: \(requestURL)")
            status = .searching
            
            if let data = persormSearchRequest(with: requestURL) {
                results = parse(data: data)
                status = results.isEmpty ? .noResult : .hasSearchResult
            }
        }
        else {
            print("search fail with text: \(encodedText!)")
        }
        
        // TODO: this line is only for test loading cell usage, need to remove it
        status = .searching
    }
    
    public func getResult(by index: Int) -> SearchResult? {
        results.getResult(by: index)
    }
    
    private func getiTuneURL(with searchText: String, number: Int = 50) -> URL? {
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=%d", searchText, number)
        return URL(string: urlString)
    }
    
    private func persormSearchRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            status = .networkError
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
