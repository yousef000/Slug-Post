//
//  message.swift
//  breakpoint
//
//  Created by Parachute on 2/18/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import Foundation

class message{
    private var _content: String
    private var _senderId: String
    
    var content: String{
        return _content
    }
    var senderId: String{
        return _senderId
    }
    //constructor
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
}
