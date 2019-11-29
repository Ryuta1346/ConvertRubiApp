//
//  UrlSessionPost.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/29.
//  Copyright © 2019 田代龍太. All rights reserved.
//

import Foundation
// リクエストのデータ形式

class URLSessionPostClient {
    
//    var inputText: String!
//    var convertText: String!

 
    struct ConvertData: Codable {
        let inputText: String
        let converText: String
    }
    
    struct WordData: Codable {
        let app_id:String
        let sentence: String
        let output_type: String
    }
    
    func postRequest(url: String, params: String) {
        let inputText: String
        let convertText: String
        
        // 外部からIDを見えないような処理をする
        let app_id = "ec67dde58dfd8c870f1d20f38c988d9f5428f51a69d2663ca28f0822b67b0c03"
        // ひらがな化APIでの変換をひらがなに指定
        let output_type = "hiragana"
   
        let inputString = params
        
        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
        // postするデータ
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
            
            let inputText = inputString
            let convertText = jsonData.converted

//            // 変換前のワードの表示
//            self.inputText.text = inputString
//            // 変換後のワードの表示
//            self.rubiText.text = jsonData.converted
            
            // 登録データ用の配列に格納するタプルを作成
            let convertWord = (inputString, jsonData.converted)
            
            // 履歴表示を5件に制限
            if convertRubiList.count < 5 {
                convertRubiList.insert(convertWord, at: 0)
            } else {
                convertRubiList.removeLast()
                convertRubiList.insert(convertWord, at: 0)
            }
            
        }
        task.resume()

    }
}
