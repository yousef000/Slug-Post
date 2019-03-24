//
//  LoginVC.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.dismissKeyboardUponTap()
        emailField.delegate = self
        passwordField.delegate = self
        
    }

    @IBAction func signInButtonWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil{
            authService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete:  { (success, loginError) in
                
                if success{
                    self.dismiss(animated: true, completion: nil)
                    
                } else{
                    print(String(describing: loginError?.localizedDescription))
                }
             
                //if user have never logged in, then register it
                authService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, registrationError) in
                    //if registration was successful then login the user
                    if success{
                        authService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            print("Succesfully registered user")
                            self.dismiss(animated: true, completion: nil)
                        })
                    } 
                })
                
                
               
            })
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        //close the loginVC
        dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate{
    
}
