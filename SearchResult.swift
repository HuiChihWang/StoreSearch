//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/4/20.
//

import Foundation


struct SearchResult: CustomStringConvertible {

    private var artistName: String?
    private var kind: String?
    var currency : String?
    
    var imageSmall: String?
    var imageLarge : String?
    
    private var trackName: String?
    private var collectionName: String?

    private var trackViewUrl: String?
    private var collectionViewUrl: String?
    
    
    private var trackPrice: Double?
    private var collectionPrice: Double?
    private var itemPrice: Double?
    
    
    private var itemGenre: String?
    private var bookGenre: [String]?

    
    var name: String {
        return trackName ?? collectionName ?? "None"
    }
    var storeURL: String {
        trackViewUrl ?? collectionViewUrl ?? "None"
    }
    
    var price: Double {
        trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    
    var genre: String {
        if let itemGenre = itemGenre {
            return itemGenre
        }
        else if let bookGenre = bookGenre {
            return bookGenre.joined(separator: ", ")
        }
        
        return "None"
    }
    
    var type: String {
        kind ?? "audiobook"
    }
    
    var artist: String {
        artistName ?? "None"
    }
    
    var description: String {
        return "\nResult - Type: \(type), Name: \(name), Artist Name: \(artist), Genre: \(genre), price: \(currency!) \(price)"
    }
    
}

extension SearchResult: Codable {
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        
        case kind, artistName, currency
        case trackName, trackViewUrl, trackPrice
        case collectionName, collectionPrice, collectionViewUrl
    }
}

extension SearchResult: Comparable {
    static func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
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
    private var results = SearchResults() {
        didSet {
            results.results.sort(by: {$0 < $1})
        }
    }
    
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
