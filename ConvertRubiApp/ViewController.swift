//
//  ViewController.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/23.
//  Copyright © 2019 田代龍太. All rights reserved.
//

import UIKit

struct WordData: Codable {
    let app_id:String
    let sentence: String
    let output_type: String
}

struct RubiData: Codable {
    let request_id: String
    let output_type: String
    let converted: String
}

class ViewController: UIViewController {

    
    @IBOutlet weak var searchtext: UISearchBar!
    @IBOutlet weak var inputText: UILabel!
    @IBOutlet weak var rubiText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

