//
//  AuthVC.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func signInWithEmailButtonWasPressed(_ sender: Any) {
        //accesing VC by ID. 
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        //show VC we want to show
        present(loginVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func googleSignInButtonWasPressed(_ sender: Any) {
    }
    
    @IBAction func facebookSignInButtonWasPressed(_ sender: Any) {
    }
}
