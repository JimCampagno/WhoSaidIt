//
//  MasterViewController.swift
//  WhoSaidIt


import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchClient = BingSearchAPIClient()
        searchClient.searchForMovieWith("Buzz Lightyear") { (imageURLS) in
            print("we have our image URLs, \(imageURLS)")
            print("the number of images we have: \(imageURLS.count)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}