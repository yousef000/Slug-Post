//
//  dataService.swift
//  breakpoint
//
//  Created by Parachute on 2/17/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class dataService {
    static let instance = dataService()
    
    private var _REF_BASE = DB_BASE                             //base database url
    private var _REF_USERS = DB_BASE.child("users")             //users database url
    private var _REF_GROUPS = DB_BASE.child("groups")           //groups database url
    private var _REF_FEED = DB_BASE.child("feed")               //feed database url
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference{
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference{
        return _REF_FEED
    }
    
    //creates firebase user and puts user's data
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    //fetch email associated with uid
    func getUsername(forUID uid: String, handler: @escaping(_ username: String) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapchot) in
            guard let userSnapchot = userSnapchot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for user in userSnapchot{
                if user.key == uid{
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    //uploads posts in group or feed
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
        if groupKey != nil{
        REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content":message, "senderId": uid])
            sendComplete(true)
        } else{
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    //fetch all posts to show in feed
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()){
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapchot) in
            guard let feedMessageSnapchot = feedMessageSnapchot.children.allObjects as?
                [DataSnapshot] else{ return }
            for message in feedMessageSnapchot{
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
                
            }
            handler(messageArray)
        }
    }
    //fetch all messages of group
    func getAllMessages(desiredGroup: Group, handler: @escaping (_ messageArray: [Message])->()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapchot) in
            guard let groupMessageSnapchot = groupMessageSnapchot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for groupMessage in groupMessageSnapchot{
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    //fetch emails that contains user search query
    func getEmail(forSearchQuery query: String,handler: @escaping (_ emails: [String]) -> ()){
        var emailArray = [String]()
        REF_USERS.observe(.value){ (userSnapchot) in
            guard let userSnapchot = userSnapchot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for user in userSnapchot{
                let email = user.childSnapshot(forPath: "email").value as! String
                //if email contains the query, and email is not equal to current user logged in
                if email.contains(query) == true && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
                
            }
            handler(emailArray)
        }
    }
    //fetch uid associated with email to add create group and add uid in that group
    func getIds(forEmails emails: [String], handler: @escaping (_ uidArray: [String]) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapchot) in
            var idArray = [String]()
            guard let userSnapchot = userSnapchot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapchot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if emails.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    //fetch Emails of users added in the group from uid
    func getEmailsFor(group: Group, handler: @escaping(_ uidArray: [String])->()){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapchot) in
            guard let userSnapchot = userSnapchot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for user in userSnapchot{
                if group.members.contains(user.key){
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    //groups are created
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool)-> () ){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids ])
        handler(true)
    }
    //fetch all goups created to show in group table View
    func getAllGroups(handler: @escaping(_ groupsArray: [Group])->()){
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapchot) in
            guard let groupSnapchot = groupSnapchot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for group in groupSnapchot{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, description: description, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
            
            }
            handler(groupsArray)
        }
    }
  
}
