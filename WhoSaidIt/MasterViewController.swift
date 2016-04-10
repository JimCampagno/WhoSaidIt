//
//  MasterViewController.swift
//  WhoSaidIt


import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchClient = BingSearchAPIClient()
        print(searchClient.baseURL)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}