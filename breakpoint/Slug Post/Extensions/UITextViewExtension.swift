//
//  UITextViewExtension.swift
//  breakpoint
//
//  Created by Parachute on 2/22/19.
//  Copyright © 2019 Parachute. All rights reserved.
//

import UIKit

extension UITextView{
    func scrollTextToBottom(){
        let bottom = NSMakeRange(self.text.count - 1, 1)
        self.scrollRangeToVisible(bottom)
        
    }
    
    
}
