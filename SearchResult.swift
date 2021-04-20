//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import Foundation

struct SearchResult {
    var name = "name"
    var artistName = "artist"
}

class SearchModel {
    private var results = [SearchResult]()
    
    var resultsNum: Int {
        results.count
    }
    
    private(set) var status = SearchStatus.notSearchedYet
    
    var isEmpty: Bool {
        status == .noResult
    }
    
    public func search(with text: String) {
        results = [SearchResult]()
        status = .searching
        
        // fake search API
        if (text != "0000") {
            (0..<5).forEach { index in
                var searchResult = SearchResult()
                searchResult.name = "fake data \(index)"
                searchResult.artistName = text
                results.append(searchResult)
            }
        }
        
        status = results.isEmpty ? .noResult : .hasSearchResult
    }
    
    public func getResult(by index: Int) -> SearchResult? {
        guard (0..<resultsNum).contains(index) else {
            return nil
        }
        
        return results[index]
    }
}

enum SearchStatus {
    case notSearchedYet
    case hasSearchResult
    case noResult
    case searching
}
