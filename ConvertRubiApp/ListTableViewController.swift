//
//  ListTableViewController.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/26.
//  Copyright © 2019 田代龍太. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var registrationList : [(input: String, output: String)] = []
    
    @IBOutlet var tableViewOnList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        // 保存しておいたデータの読み込み処理
        if let loadList = userDefaults.object(forKey: "list") as? [[String: Any]] {
            // 辞書の配列をタプルの配列へ変換
            let wordSet = loadList.map { (input: $0["input"] as! String, output: $0["output"] as! String)}
            registrationList.insert(contentsOf: wordSet, at: 0)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListTableViewCell = tableViewOnList.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        
        // セルに表示する値を設定
        cell.inputCharacterInList!.text = registrationList[indexPath.row].input
        cell.outputCharacterInList!.text = registrationList[indexPath.row].output
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // リストから削除
            registrationList.remove(at: indexPath.row)
            //セルを削除
            tableViewOnList.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            do {
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: registrationList, requiringSecureCoding: true)
                
            } catch {
                
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
