//
//  postVC.swift
//  breakpoint
//
//  Created by Parachute on 2/18/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit
import Firebase

class postVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.view.dismissKeyboardUponTap()
        textView.scrollTextToBottom()
        sendButton.bindToKeyboard()
        //update emailLabel
        dataService.instance.getUsername(forUID: (Auth.auth().currentUser?.uid)!) { (returnedEmail) in
            self.emailLabel.text = returnedEmail
        }
        // Do any additional setup after loading the view.
    }
   

    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if textView.text != nil && textView.text.count > 150{
            sendButton.isEnabled = false
            dataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (isComplete) in
                if isComplete{
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else{
                    self.sendButton.isEnabled = true
                    print("There was an error...")
                }
            }
        }
    }
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
}
extension postVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Post something here..                              minimum characters = 150                          maximum charcters = 500         "{
            textView.text = ""
        }
       
    }
    //limit post text characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500    // 500 Limit Value
    }
}
