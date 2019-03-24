//
//  FirstViewController.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var messageArray = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.layer.shouldRasterize = true
        self.view.layer.rasterizationScale = UIScreen.main.scale;
        
        
    }
   
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        dataService.instance.getAllFeedMessages { (returnedMessagesArray) in
            self.messageArray = returnedMessagesArray.reversed()
            self.tableView.reloadData()
        }
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? feedCell
        else {
            return UITableViewCell()
        }
        let image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row]

        dataService.instance.getUsername(forUID: message.senderId) { (returnedUsername) in
            //get username from email
            let endOfSeqeuence = returnedUsername.firstIndex(of: "@")
            let firstSequence = returnedUsername[..<endOfSeqeuence!]
            cell.selectionStyle = .none
            //to avoid cell not displaying whole text
            let trimmed = message.content.replacingOccurrences(of: "\n", with: " ")
            
            cell.configureCell(profileImage: image!, email: String(firstSequence), content: trimmed)
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageArray[indexPath.row]
        return CGFloat(message.content.count)
    }
    
    
  
    
    
    
    
}
