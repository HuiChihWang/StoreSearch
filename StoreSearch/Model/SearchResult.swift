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

