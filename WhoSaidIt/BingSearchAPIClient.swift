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
    var baseURLString: String  {
        let urlString = "https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27image%27&$top=\(numberOfPhotos)&$format=\(format.rawValue)"
        if let imageSize = imageSize {
            let imageSizeQuery = "&ImageFilters=%27Size%3A\(imageSize.rawValue)%27"
            let urlStringWithImageSizeQuery = urlString + imageSizeQuery
            return urlStringWithImageSizeQuery
        }
        return urlString
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
    
    typealias MovieImageClosure = ([String]) -> ()
    
    func searchForMovieWith(query: String, completion: MovieImageClosure) {
        
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let searchQuery = "%27\(escapedQuery)%27"
        let queryParam = "&Query=\(searchQuery)"
        let urlString = baseURLString + queryParam
        
        guard let url = NSURL(string: urlString) else { fatalError("Could not create NSURL object.") }
        
        let session = NSURLSession.sharedSession()
        var request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        
        
        

//        
//        
//        NSString *escpaedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSString *searchQuery = [NSString stringWithFormat:@"%%27%@%%27", escpaedQuery];
//        NSString *urlString = [NSString stringWithFormat:@"https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%%27image%%27&$top=3&$format=json&Query=%@", searchQuery];
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        NSURLSession *sharedSession = [NSURLSession sharedSession];
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        NSString *value = @"Basic OnpvWkhHb2hrc2lZQ1ovV2l3cDRIa0hMdEJBdERqVjZzQ1R2aDFxTFR0ZFE=";
//        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request addValue:value forHTTPHeaderField:@"Authorization"];
//        
//        __block NSMutableArray *imageURLS = [NSMutableArray new];
//        
//        NSURLSessionDataTask *dataTask =
//        [sharedSession dataTaskWithRequest:request
//        completionHandler:^(NSData * _Nullable data,
//        NSURLResponse * _Nullable response,
//        NSError * _Nullable error) {
//        if (error) {
//        NSLog(@"%@", error.localizedDescription);
//        }
//        
//        if (response) {
//        }
//        
//        if (data) {
//        NSData *dataThing = (NSData *)data;
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataThing options:kNilOptions error:&error];
//        
//        NSDictionary *d = jsonDict[@"d"];
//        NSArray *results = d[@"results"];
//        
//        if (results.count >= 1) {
//        NSDictionary *result = results[0];
//        NSArray *images = result[@"Image"];
//        
//        for (NSDictionary *image in images) {
//        NSString *mediaURL = image[@"MediaUrl"];
//        [imageURLS addObject:mediaURL];
//        }
//        }
//        
//        NSLog(@"imageURLS: %@", imageURLS);
//        }
//        }];
//        
//        [dataTask resume];
        
        
        
        
    }
    
    
    
}
