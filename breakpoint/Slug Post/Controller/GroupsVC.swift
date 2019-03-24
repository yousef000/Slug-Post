//
//  SecondViewController.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //whenever changes happen to groups, it updates 
        dataService.instance.REF_GROUPS.observe(.value) { (snapchot) in
            dataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.tableView.reloadData()
            }
        }
        
    }

}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? groupCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configureCell(title: groupsArray[indexPath.row].groupTitle, description: groupsArray[indexPath.row].groupDescription, memberCount: groupsArray[indexPath.row].memberCount)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "groupFeedVC") as? groupFeedVC else {
            return
        }
        //initialize data of groups selected from group list
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        //present groups selected from group list
        presentDetail(groupFeedVC)
       
    }
}
