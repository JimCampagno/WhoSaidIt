//
//  WikiQuotesAPIClient.swift
//  WhoSaidIt


import Foundation
import HTMLReader

final class WikiQuotesAPIClient {
    
    let baseURL = "http://en.wikiquote.org/w/api.php?format=json&action=parse&prop=text&page="
    
}

// MARK: Search Functions
extension WikiQuotesAPIClient {
    
    typealias WikiQuotesClosure = ([String: AnyObject]) -> ()
    
    func getFilmInfoWith(query: String, completion: WikiQuotesClosure) {
        var people = [String: AnyObject]()
        
        let urlString = baseURL + query
        guard let url = NSURL(string: urlString) else { fatalError("Could not create NSURL object in getFilmInfoWith:.") }
        
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let error = error { print(error.localizedDescription); return }
            
            var contentType: String?
            
            if let response = response as? NSHTTPURLResponse {
                let headers = response.allHeaderFields
                if let content = headers["Content-Type"] as? String {
                    contentType = content
                }
            }
            guard let data = data else { fatalError("Bypassed error, yet we have no data object.") }
            let home = HTMLDocument(data: data, contentTypeHeader: contentType)
            guard let elements = home.rootElement?.children.array as? [HTMLElement] else { fatalError("Can't create children array off of rootElement from HTMLDocument.") }
            
            var character = ""
            
            for element in elements {
                for node in element.children {
                    if self.isHeading2(node) {
                        character = node.textContent.stringByReplacingOccurrencesOfString("[edit]", withString: "")
                        people[character] = [String]()
                    } else if self.isUnorderedList(node) {
                        let textContent = node.textContent
                        let quotes = textContent.componentsSeparatedByString("\\n")
                        
                        for rawQuote in quotes {
                            var quote = rawQuote
                            var rangeOfLowercaseU = quote.rangeOfString("\\u", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            var rangeOfUppercaseU = quote.rangeOfString("\\U", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            
                            while rangeOfLowercaseU != nil {
                                let range = rangeOfLowercaseU!
                                let extendedRange = range.startIndex...range.startIndex.advancedBy(4)
                                quote = quote.stringByReplacingCharactersInRange(extendedRange, withString: " ")
                                rangeOfLowercaseU = quote.rangeOfString("\\u", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            }
                            
                            while rangeOfUppercaseU != nil {
                                let range = rangeOfUppercaseU!
                                let extendedRange = range.startIndex...range.startIndex.advancedBy(4)
                                quote = quote.stringByReplacingCharactersInRange(extendedRange, withString: " ")
                                rangeOfUppercaseU = quote.rangeOfString("\\U", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            }
                            
                            quote = quote.stringByReplacingOccurrencesOfString("\\", withString: "")
                            
                            if !quote.isEmpty {
                                if let quotes = people[character] as? [String] {
                                    var newQuotes = quotes
                                    newQuotes.append(quote)
                                    people[character] = newQuotes
                                }
                            }
                        }
                    }
                }
            }
            
            let actors = people as! [String: [String]]
            self.createMovie(query, withActors: actors)
//            completion(people)
        }
        
        dataTask.resume()
    }
}

// MARK: HTMLElement Introspection Methods
extension WikiQuotesAPIClient {
    
    private func isUnorderedList(element: AnyObject) -> Bool {
        return isElement(element, forString: "ul")
    }
    
    private func isHeading2(element: AnyObject) -> Bool {
        return isElement(element, forString: "h2")
    }
    
    private func isElement(element: AnyObject, forString string: String) -> Bool {
        return (element.isKindOfClass(HTMLElement) && HTMLSelector(forString: "\(string)").matchesElement(element as! HTMLElement))
    }
    
}


// MARK: Parse Methods to create Movie Objects
extension WikiQuotesAPIClient {
    
    private func createMovie(movie: String, withActors actors: [String: [String]]) {
        let newMovie = Movie(movieTitle: movie, movieImageURL: nil)
        
        for (actor, quotes) in actors {
            if actor.lowercaseString.containsString("about") { continue }
            let newActor = Actor(name: actor, movie: newMovie, quotes: quotes)
            newMovie.actors.append(newActor)
        }
        

        for actor in newMovie.actors {
            print("--------------------")
            print(actor)
            print("--------------------\n\n\n")
        }
        
        
        
        
    }
    
    
}






