//
//  feedCell.swift
//  breakpoint
//
//  Created by Parachute on 2/18/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class feedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    func configureCell(profileImage: UIImage, email: String, content: String){
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = content
    }
}
