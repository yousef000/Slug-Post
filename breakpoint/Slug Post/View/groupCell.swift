//
//  groupCell.swift
//  breakpoint
//
//  Created by Parachute on 2/21/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class groupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var groupMemberLabel: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int){
        self.groupTitleLabel.text = title
        self.groupDescriptionLabel.text = description
        self.groupMemberLabel.text = "\(memberCount) members."
    }
    
}
