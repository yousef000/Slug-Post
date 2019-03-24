//
//  groupFeedVC.swift
//  breakpoint
//
//  Created by Parachute on 2/22/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit
import Firebase

class groupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group){
        self.group = group
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.dismissKeyboardUponTap()
        view.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.groupTitle
        dataService.instance.getEmailsFor(group: self.group!) { (returnedEmails) in
            
            var usernames = [String]()
            for email in returnedEmails{
                //get username from email
                let endOfSeqeuence = email.firstIndex(of: "@")
                let firstSequence = email[..<endOfSeqeuence!]
                usernames.append(String(firstSequence))
            }
            self.membersLabel.text = usernames.joined(separator: ", ")
        }
        dataService.instance.REF_GROUPS.observe(.value) { (snapchot) in
            dataService.instance.getAllMessages(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .bottom, animated: true)
                }
            })
        }
        
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        
        if messageTextField.text != ""{
            messageTextField.resignFirstResponder()
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            dataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key) { (complete) in
                if complete{
                    self.messageTextField.text = ""
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                }
            }
        }
    }
    
}
extension groupFeedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? groupFeedCell else{
            return UITableViewCell()
        }
        let message = groupMessages[indexPath.row]
        dataService.instance.getUsername(forUID: message.senderId) { (email) in
            //get username from email
            let endOfSeqeuence = email.firstIndex(of: "@")
            let firstSequence = email[..<endOfSeqeuence!]
            cell.selectionStyle = .none
            
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: String(firstSequence), content: message.content)
            
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = groupMessages[indexPath.row]
        if message.content.count < 150{
            return 150
        }
        return CGFloat(message.content.count)
    }
}

extension groupFeedVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 500
    }
}
    

