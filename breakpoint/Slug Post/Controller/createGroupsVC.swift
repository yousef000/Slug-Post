//
//  createGroupsVC.swift
//  breakpoint
//
//  Created by Parachute on 2/20/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit
import Firebase

class createGroupsVC: UIViewController{

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var emailSearchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var groupMemberLabel: UILabel!
    
    var emailArray = [String]()             //emails that contains user's search queries
    var chosenUserArray = [String]()            //emails chosen to be added in the group by user
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self

        //recognizes changes in email text field -- when user start editing
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doneButton.isHidden = true
    }
    @objc func textFieldDidChange(){
        if emailSearchTextField.text == ""{
            emailArray = []
            tableView.reloadData()
        }
        else{
            dataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!) { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            }
        }
    }
 
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        if titleTextField.text != "" && descriptionTextField.text != ""{
            dataService.instance.getIds(forEmails: chosenUserArray) { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                dataService.instance.createGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated{
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        print("Error")
                    }
                })
                
            }
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 

}
extension createGroupsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? userCell else {
            return UITableViewCell()
        }
        let profileImage = UIImage(named: "defaultProfileImage")
        if chosenUserArray.contains(emailArray[indexPath.row]){
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else{
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? userCell else{
            return
        }
        //if chosenarray doesn't contain email yet, then add it
        if !chosenUserArray.contains(cell.emailLabel.text!){
            chosenUserArray.append(cell.emailLabel.text!)
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            doneButton.isHidden = false
        } else{
            //delete the user from chosenUserArray
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text})
            if chosenUserArray.count > 0{
                groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            } else{
                groupMemberLabel.text = "_add people to your group"
                doneButton.isHidden = true
            }
        }
        
    }
}
extension createGroupsVC: UITextFieldDelegate{
    
}

