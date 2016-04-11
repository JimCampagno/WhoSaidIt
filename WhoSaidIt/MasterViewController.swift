//
//  MasterViewController.swift
//  WhoSaidIt


import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wikiQuotesClient = WikiQuotesAPIClient()
        wikiQuotesClient.getFilmInfoWith("Up_(2009_film)") { (stuff) in
            
        }
        
//        let searchClient = BingSearchAPIClient()
//        searchClient.searchForMovieWith("Buzz Lightyear") { (imageURLS) in
//            print("we have our image URLs, \(imageURLS)")
//            print("the number of images we have: \(imageURLS.count)")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}