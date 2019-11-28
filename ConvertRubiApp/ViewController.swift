//
//  ViewController.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/23.
//  Copyright © 2019 田代龍太. All rights reserved.
//


import UIKit

// リクエストのデータ形式
struct WordData: Codable {
    let app_id:String
    let sentence: String
    let output_type: String
}

// レスポンスのデータ形式
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
        
        registerButton.setTitle("リスト登録", for: .normal)
    }

    // 編集が開始されたら、キャンセルボタンを有効にする
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        // 編集開始したら、前回の変換処理時に変更していたボタン状態を戻す
        registerButton.setTitle("リスト登録", for: .normal)
        registerButton.setTitleColor(UIColor.blue, for: .normal)
        registerButton.isEnabled = true
        return true
    }

    // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスを外す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    // サーチバーがクリックされた時の処理
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 外部からIDを見えないような処理をする
        let app_id = "app_id"
        // ひらがな化APIでの変換をひらがなに指定
        let output_type = "hiragana"
        // キーボードを閉じる
        view.endEditing(true)
        
        guard let inputString = searchText.text else {
            return
        }
            
        // リクエスト処理
        // ひらがな化APIはPOST形式でリクエスト受け付ける
        var request = URLRequest(url: URL(string: "https://labs.goo.ne.jp/api/hiragana")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // POSTするデータを設定
        let wordData = WordData(app_id: app_id, sentence: inputString, output_type: output_type)
            
        // POSTするデータのエンコード処理
        guard let uploadData = try? JSONEncoder().encode(wordData) else {
                print("json生成失敗")
                return
            }
        request.httpBody = uploadData
            
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
        // requestにuploadDataをアップロード
        // POSTやPUTの場合にはuploadTaskを使用
        let task = session.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
                
            // 200番台以外のエラーをserver errorとして処理
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
            // Buttonは即表示させる
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "convertCell", for: indexPath) as! ConvertRubiTableViewCell
        
        // セルに表示する値を設定
        cell.inputCharacter!.text = convertRubiList[indexPath.row].input
        cell.outputCharacter!.text = convertRubiList[indexPath.row].output
                
        return cell
    }
    
    // 画面遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toListTableView" {
            // 次の画面を取り出す
            _ = segue.destination as! ListTableViewController
        
        }
    }
     
    @IBAction func tapRegistrationButton(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard

        // 変換前後のワードをregistrationListに登録
        let wordSet = (convertRubiList[0])
        registrationList.insert(wordSet, at: 0)
        
        // UserDefaultsに保存できるようにタプルの配列を辞書の配列へ変換
        let saveList: [[String: Any]] = registrationList.map { ["input": $0.input,  "output": $0.output] }

        // UserDefaultsに保存できる形式に処理したデータを保存させる
        userDefaults.set(saveList, forKey: "list")
        
        // 登録したらそのワードを連続で登録させないように処理
        registerButton.setTitle("登録しました", for: .normal)
        registerButton.setTitleColor(UIColor.red, for: .normal)
        registerButton.isEnabled = false

        }
}

