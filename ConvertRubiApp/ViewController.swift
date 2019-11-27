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

// 変換履歴用のデータを格納する
var convertRubiList : [(input: String, output: String)] = []

// 登録リスト用のデータを格納する
var registrationList : [(input: String, output: String)] = []

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var inputText: UILabel!
    @IBOutlet weak var rubiText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // SearchBarのdelegate通知先設定
        searchText.delegate = self
        
        // プレースホルダーを設定
        searchText.placeholder = "ルビをつけたいワードを入力してください"
        
        tableView.dataSource = self
        
        // TableViewのスクロールをオフに
        tableView.isScrollEnabled = false
        
    }

    
    // サーチバーがクリックされた時の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 外部からIDを見えないような処理をする
        let app_id = "app_id"
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

            // 変換前のワードの表示
            self.inputText.text = inputString
            // 変換後のワードの表示
            self.rubiText.text = jsonData.converted
            
            // 登録データ用の配列に格納するタプルを作成
            let convertWord = (inputString, jsonData.converted)
            
            // 履歴表示を5件に制限
            if convertRubiList.count < 5 {
                convertRubiList.insert(convertWord, at: 0)
            } else {
                convertRubiList.removeLast()
                convertRubiList.insert(convertWord, at: 0)
            }
                                          
            // 履歴表示用のTableViewの表示データ更新
            self.tableView.reloadData()
                
            // 引数のwithDurationでアニメーションの処理時間を指定
            // Buttonなので即表示させる
            UIButton.animate(withDuration: 0.0, animations: {
                // アルファ値を1.0に変化させる(初期値はStoryboardで0.0に設定済み)
                self.registerButton.alpha = 1.0
            })
        }
        
        
        
        task.resume()
    }

    // TableViewにタイトル表示
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "変換履歴(5件)"
    }
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertRubiList.count
    }
    
    // セルを返す(表示を5つだけにしたい)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルにテキストを出力
        let cell : ConvertRubiTableViewCell = tableView.dequeueReusableCell(withIdentifier: "convertCell", for: indexPath) as! ConvertRubiTableViewCell
        
        // セルに表示する値を設定
        cell.inputCharacter!.text = convertRubiList[indexPath.row].input
        cell.outputCharacter!.text = convertRubiList[indexPath.row].output
                
        return cell
    }
    
    // 画面遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toListTableView" {
            // 次の画面を取り出す
            let listTableView = segue.destination as! ListTableViewController
        
        }
    }
     
    @IBAction func tapRegistrationButton(_ sender: Any) {
        
        let wordSet = (convertRubiList[0])
        registrationList.insert(wordSet, at: 0)
        print(registrationList)

    }
    
}

