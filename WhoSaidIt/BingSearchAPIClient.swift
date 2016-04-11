//
//  BingSearchAPIClient.swift
//  WhoSaidIt


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
            numberOfPhotos = min(numberOfPhotos, 5)
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
    var imageSize: ImageSize?
    
    
    // MARK: Initializers
    init() {}
    
    convenience init(numberOfPhotos: Int, format: Format, imageSize: ImageSize?) {
        self.init()
        self.numberOfPhotos = min(numberOfPhotos, 5)
        self.format  = format
        self.imageSize = imageSize
    }
    
}

// MARK: Search Methods
extension BingSearchAPIClient {
    
    typealias MovieImageClosure = ([String]) -> ()
    
    /// This function takes two arguments. One of type string that represents the query, the other a closure that when called takes an argument of type [String] with no return type. The caller can search for anything here to receive back (through the completion closure) an array of ImageURLS of type String. This instance method should be getting called to provide images back to the model to supply it with imageURLS for any actors or movies that need it. I'm using a free account, limited to **5,000** queries a month.
    func searchForMovieWith(query: String, completion: MovieImageClosure) {
        guard let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else { print("Unable to encode the query"); return }
        let searchQuery = "%27\(escapedQuery)%27"
        let queryParam = "&Query=\(searchQuery)"
        let urlString = baseURLString + queryParam
        
        guard let url = NSURL(string: urlString) else { fatalError("Could not create NSURL object.") }
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bingSearchAccountKey, forHTTPHeaderField: "Authorization")
        
        var imageURLS = [String]()
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            if let response = response { print(response) }
            guard let data = data else { fatalError("Bypassed error, yet we have no data object.") }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
                if let d = json["d"] {
                    if let results = d["results"] as? [[String: AnyObject]] {
                        if !results.isEmpty {
                            let result = results[0]
                            if let images = result["Image"] as? [[String: AnyObject]] {
                                for image in images {
                                    if let imageURL = image["MediaUrl"] as? String {
                                        imageURLS.append(imageURL)
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print(":( what happened to the JSON serialization?.")
            }
            completion(imageURLS)
        }
        
        dataTask.resume()
    }
    
}
