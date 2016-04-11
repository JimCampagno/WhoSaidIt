//
//  Movie.swift
//  WhoSaidIt


import Foundation
import UIKit

final class Movie {
    
    let movieTitle: String
    var movieImageURL: String?
    var movieImage: UIImage?
    var actors: [Actor] = []
    
    init(movieTitle: String, movieImageURL: String?) {
        self.movieTitle = movieTitle
        self.movieImageURL = movieImageURL ?? nil
    }

}

// MARK: Quote Methods
extension Movie {
    
    func actorWhoSaidQuote(quote: String) -> Actor? {
        for actor in actors {
            if actor.didSay(quote) { return actor }
        }
        return nil
    }
    
}
