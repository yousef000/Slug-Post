//
//  userCell.swift
//  breakpoint
//
//  Created by Parachute on 2/21/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class userCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
 
    var showing = false
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool){
        self.profileImage.image = image
        self.emailLabel.text = email
        if isSelected{
            self.checkImage.isHidden = false
        }
        else{
            self.checkImage.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if showing == false{
                checkImage.isHidden = false
                showing = true
            }
            
            else{
                checkImage.isHidden = true
                showing = false
            }
        }
    }

}
