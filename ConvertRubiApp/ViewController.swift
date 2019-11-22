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

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var inputText: UILabel!
    @IBOutlet weak var rubiText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // SearchBarのdelegate通知先設定
        searchText.delegate = self
        //
        searchText.placeholder = "ルビをつけたいワードを入力してください"
    }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            let app_id = "app_idを登録"
            let output_type = "hiragana"
            // キーボードを閉じる
            view.endEditing(true)
            
            guard let inputString = searchText.text else {
                return
            }
            
            var request = URLRequest(url: URL(string: "https://labs.goo.ne.jp/api/hiragana")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let wordData = WordData(app_id: app_id, sentence: inputString, output_type: output_type)
            
            guard let uploadData = try? JSONEncoder().encode(wordData) else {
                    print("json生成失敗")
                    return
                }
            request.httpBody = uploadData
            
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }
                
                guard let data = data, let jsonData = try? JSONDecoder().decode(RubiData.self, from: data) else {
                    print("json変換に失敗しました")
                    return
                }
                print(jsonData.converted)
                self.inputText.text = inputString
                self.rubiText.text = jsonData.converted
            }
            task.resume()
        }
}

