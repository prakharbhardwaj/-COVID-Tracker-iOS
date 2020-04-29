//
//  IndiaDetailCell.swift
//  COVIDtracker
//
//  Created by Prakhar Prakash Bhardwaj on 20/03/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class IndiaDetailCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var recovery: UILabel!
    @IBOutlet weak var newDeath: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var newRecovery: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView?.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
