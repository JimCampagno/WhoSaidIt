//
//  BingSearchAPIClient.swift
//  WhoSaidIt
//
//  Created by Jim Campagno on 4/9/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import Foundation
import HTMLReader

enum ImageSize: String {
    case Small, Medium, Large
}

enum Format: String {
    case JSON = "json"
    case XML = "atom"
}

final class BingSearchAPIClient {
    
    // MARK: Properties
    var numberOfPhotos: Int = 3 {
        didSet {
            assert(numberOfPhotos <= 10, "Attempt to set numberOfPhotos on request to be larger than 10.")
            if numberOfPhotos > 10 { numberOfPhotos = 10 }
        }
    }
    var baseURL: NSURL  {
        print("Inside of baseURL")
        let urlString = "https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27image%27&$top=\(numberOfPhotos)&$format=\(format.rawValue)"

        if let imageSize = imageSize {
            let imageSizeQuery = "&ImageFilters=%27Size%3A\(imageSize.rawValue)%27"
            let urlStringWithImageSizeQuery = urlString + imageSizeQuery
            return NSURL(string: urlStringWithImageSizeQuery)!
        }
        
        return NSURL(string: urlString)!
    }
    var format: Format = .JSON
    var imageSize: ImageSize? // Not required
    
    // MARK: Initializers
    init() {}
    
    convenience init(numberOfPhotos: Int, format: Format, imageSize: ImageSize?) {
        self.init()
        self.numberOfPhotos = numberOfPhotos
        self.format  = format
        self.imageSize = imageSize
    }
    
}

// MARK: Search Methods
extension BingSearchAPIClient {
    
    
    
}
