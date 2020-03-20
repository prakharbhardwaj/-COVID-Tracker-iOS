//
//  PetitionTableViewCell.swift
//  JSONCodables
//
//  Created by Prakhar Prakash Bhardwaj on 15/11/19.
//  Copyright © 2019 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class PetitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var recovery: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
