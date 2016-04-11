//
//  Actor.swift
//  WhoSaidIt
//
//  Created by Jim Campagno on 4/10/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import UIKit
import GameKit

final class Actor {
    
    let name: String
    var movie: String
    var quotes: [String] = []
    var imageURLS: [String] = []
    var images: [UIImage] = []
    var displayImage: UIImage? {
        if images.isEmpty { return nil }
        let randomCount = GKRandomSource.sharedRandom().nextIntWithUpperBound(images.count)
        let image = images[randomCount]
        return image
    }
    
    init(name: String, movie: String, quotes: [String]?, imageURLS: [String]? ) {
        self.name = name
        self.movie = movie
        if let quotes = quotes { self.quotes = quotes }
        if let imageURLS = imageURLS { self.imageURLS = imageURLS }
    }
    
    
    
    
    
}