//
//  profileVC.swift
//  breakpoint
//
//  Created by Parachute on 2/18/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit
import Firebase

class profileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //update emailLabel
        dataService.instance.getUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
            self.emailLabel.text = returnedEmail
        }
      
    }
    
    
    @IBAction func signOutButtonWasPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
                
            } catch{
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
   

}

