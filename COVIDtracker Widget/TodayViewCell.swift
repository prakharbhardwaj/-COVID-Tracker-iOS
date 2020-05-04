//
//  TodayViewCell.swift
//  COVIDtracker Widget
//
//  Created by Prakhar Prakash Bhardwaj on 03/05/20.
//  Copyright © 2020 Prakhar Prakash Bhardwaj. All rights reserved.
//

import UIKit

class TodayViewCell: UITableViewCell {
    
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var death: UILabel!
    @IBOutlet weak var cases: UILabel!
    @IBOutlet weak var newDeath: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var newRecovery: UILabel!
    @IBOutlet weak var recovery: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusLoader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView?.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
