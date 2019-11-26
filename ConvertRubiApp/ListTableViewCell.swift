//
//  ListTableViewCell.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/27.
//  Copyright © 2019 田代龍太. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var inputCharacterInList: UILabel!
    @IBOutlet weak var outputCharacterInList: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
