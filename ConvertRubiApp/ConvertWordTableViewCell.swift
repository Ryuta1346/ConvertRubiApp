//
//  ConvertWordTableViewCell.swift
//  ConvertRubiApp
//
//  Created by 田代龍太 on 2019/11/24.
//  Copyright © 2019 田代龍太. All rights reserved.
//

import UIKit

class ConvertWordTableViewCell: UITableViewCell {

    @IBOutlet weak var inputCharacter: UILabel!
    @IBOutlet weak var outputCharacter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
