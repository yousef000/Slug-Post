//
//  authService.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import Foundation
import Firebase

class authService{
    static let instance = authService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping
        (_ status: Bool, _ error: Error?) -> ()){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            //if there's a user otherwise return error
            guard let authResult = authResult?.user else{
                userCreationComplete(false, error)
                return
            }
            //provider can be google, facebook, email etc.
            let userData = ["provider": authResult.providerID, "email": authResult.email]
            //puts user in database
            dataService.instance.createDBUser(uid: authResult.uid, userData: userData as Dictionary<String, Any>)
            //user creation is complete
            userCreationComplete(true, nil)
        }
        
    }
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                loginComplete(false,nil)
                return
            }
            loginComplete(true,nil)
            
            
        }
    }
}
