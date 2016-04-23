//
//  Actor.swift
//  WhoSaidIt


import Foundation
import UIKit
import GameKit

final class Actor {
    
    let name: String
    unowned let movie: Movie
    let quotes: [String]
    var imageURLS: [String] = []
    var images: [UIImage] = []
    var displayImage: UIImage? {
        if images.isEmpty { return nil }
        let randomCount = GKRandomSource.sharedRandom().nextIntWithUpperBound(images.count)
        let image = images[randomCount]
        return image
    }
    
    init(name: String, movie: Movie, quotes: [String]) {
        self.name = name
        self.movie = movie
        self.quotes = quotes
    }
    
}

// MARK: Quote Methods
extension Actor {
    
//    func didSay(quote: String) -> Bool {
//        return !quotes.filter { actorQuote in
//            return actorQuote == quote
//        }.isEmpty
//    }
    
}

// MARK: Protocols

extension Actor: CustomStringConvertible {
    var description: String {
        var descriptionDictionary: [String: AnyObject] = [:]
        descriptionDictionary["name"] = name
        descriptionDictionary["quotes"] = quotes
        descriptionDictionary["movie"] = movie.movieTitle
        return "\(descriptionDictionary)"
    }
}

extension Actor: Equatable {}
func ==(lhs: Actor, rhs: Actor) -> Bool {
    return lhs.name == rhs.name && lhs.hashValue == rhs.hashValue
}

extension Actor: Hashable {
    var hashValue: Int {
        return quotes.reduce(0) { initial, quote in
            initial + quote.hashValue
        }
    }
}
