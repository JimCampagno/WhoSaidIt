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
    
    typealias WikiQuotesClosure = ([[String: AnyObject]]) -> ()
    
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
            
            var character: String
            
            for element in elements {
                for node in element.children {
                    if self.isHeading2(node) {
                        character = node.textContent.stringByReplacingOccurrencesOfString("edit", withString: "")
                        //TODO: Is the value supposed to be an Array of String's?
                        people[character] = [String]()
                    } else if self.isUnorderedList(node) {
                        let textContent = node.textContent
                        let quotes = textContent.componentsSeparatedByString("\n")
                        for rawQuote in quotes {
                            var quote = rawQuote
                            var rangeOfLowercaseU = quote.rangeOfString("\\u", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            var rangeOfUppercaseU = quote.rangeOfString("\\U", options: NSStringCompareOptions.BackwardsSearch, range: nil, locale: nil)
                            
                            
                            
                            while rangeOfLowercaseU != nil {
                                let range = rangeOfLowercaseU!
                                let extendedRange = Range.init(start: range.startIndex, end: range.startIndex + 4)
                                
//                                let rangeFourCharactersOut = Range(rangeOfLowercaseU.)
                                
                                
                            }
                            
                           
                        
                            
                            
                        }
                        
                        
                        
                        
                    }
                    

                    //
                    //    while (range.length != 0) {
                    //    NSRange newRange = NSMakeRange(range.location, range.length + 4);
                    //    quote = [quote stringByReplacingCharactersInRange:newRange
                    //    withString:@" "];
                    //    range = [quote rangeOfString:@"\\u" options: NSBackwardsSearch];
                    //    }

                    
                    
                }
            }
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






//    for (HTMLElement *element in elements) {
//    for (HTMLElement *node in element.children) {
//
//    if ([self isHeading2HTMLElement:node]) {
//    character = [node.textContent stringByReplacingOccurrencesOfString:@"[edit]"
//    withString:@""];
//    [people setObject:[@[] mutableCopy]
//    forKey:character];
//
//    } else if ([self isUnorderedListHTMLElement:node]) {
//
//    NSString *thing = node.textContent;
//    NSArray *quotes = [thing componentsSeparatedByString:@"\\n"];
//
//    for (NSInteger i = 0; i < quotes.count; i++) {
//    NSString *quote = quotes[i];
//
//    NSRange range;
//    NSRange otherRange;
//    range = [quote rangeOfString:@"\\u" options: NSBackwardsSearch];
//    otherRange = [quote rangeOfString:@"\\U" options:NSBackwardsSearch];
//
//    while (range.length != 0) {
//    NSRange newRange = NSMakeRange(range.location, range.length + 4);
//    quote = [quote stringByReplacingCharactersInRange:newRange
//    withString:@" "];
//    range = [quote rangeOfString:@"\\u" options: NSBackwardsSearch];
//    }
//
//    while (otherRange.length != 0) {
//    NSRange newRange = NSMakeRange(range.location, range.length + 4);
//    quote = [quote stringByReplacingCharactersInRange:newRange
//    withString:@" "];
//    range = [quote rangeOfString:@"\\U" options: NSBackwardsSearch];
//    }
//
//
//
//    quote = [quote stringByReplacingOccurrencesOfString:@"\\"
//    withString:@""];
//
//
//
//    if (quote.length >= 1) {
//    [people[character] addObject:quote];
//    }
//
//
//
//    }
//    }
//    }
//    }
//
//    NSLog(@"%@", people);
//
//    }];
//
//    [dataTask resume];
//    }
//
//
//
//
//    - (BOOL)isUnorderedListHTMLElement:(HTMLElement *)element {
//        return ([element isKindOfClass:[HTMLElement class]] && [[HTMLSelector selectorForString:@"ul"] matchesElement:element]);
//        }
//
//        - (BOOL)isHeading2HTMLElement:(HTMLElement *)element {
//            return ([element isKindOfClass:[HTMLElement class]] && [[HTMLSelector selectorForString:@"h2"] matchesElement:element]);
//            }
//
//            - (BOOL)isSpecificElementString:(NSString *)string withElement:(HTMLElement *)element {
//                return ([element isKindOfClass:[HTMLElement class]] && [[HTMLSelector selectorForString:string] matchesElement:element]);
//}