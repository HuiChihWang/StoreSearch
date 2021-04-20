//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import Foundation


struct SearchResult: Codable {
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case storeURL = "trackViewUrl"
        case genre = "primaryGenreName"
        case kind, artistName, trackName
        case trackPrice, currency
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    var storeURL: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var genre = ""
}

class SearchResults: Codable {
    var resultCount = 0
    var results = [SearchResult]()
    
    
    var isEmpty: Bool {
        results.isEmpty
    }
    
    func getResult(by index: Int) -> SearchResult? {
        guard (0..<resultCount).contains(index) else {
            return nil
        }
        return results[index]
    }
    
    
}

class SearchModel {
    private var results = SearchResults()
    
    var resultsNum: Int {
        results.resultCount
    }
    
    private(set) var status = SearchStatus.notSearchedYet
    
    var isEmpty: Bool {
        status == .noResult
    }
    
    public func search(with text: String) {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let searchText = encodedText, let requestURL = getiTuneURL(with: searchText) {
            print("searching with text: \(requestURL)")
            
            // TODO: need to dig again
            status = .searching

            if let data = persormSearchRequest(with: requestURL) {
                results = parse(data: data)
                status = results.isEmpty ? .noResult : .hasSearchResult
            }
        }
        else {
            print("search fail with text: \(encodedText!)")
        }
    }
    
    public func getResult(by index: Int) -> SearchResult? {
        results.getResult(by: index)
    }
    
    private func getiTuneURL(with searchText: String) -> URL? {
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", searchText)
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
        
        // parsing error
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
