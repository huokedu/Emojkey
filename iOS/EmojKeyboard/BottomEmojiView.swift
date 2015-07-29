//
//  BottomEmojiView.swift
//  EmojKey
//
//  Created by Matthew Carlson on 7/27/15.
//  Copyright (c) 2015 Matthew Carlson. All rights reserved.
//

import Foundation
import UIKit

class BottomEmojiView: UIView{
    
    let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        print("Bottom view started");
        self.userInteractionEnabled = true;
        
        //self.nextKeyboardButton.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        
        
        if let buttonIcon = UIImage(named: "keyboardswitch") {
            nextKeyboardButton.frame = CGRectMake(0.0, frame.height-30, 30, frame.height)
            nextKeyboardButton.setBackgroundImage(buttonIcon, forState: UIControlState.Normal)
        }
        
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        self.addSubview(self.nextKeyboardButton)
        //var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)
        //var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        //self.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextButtonTarget(target:AnyObject, action:Selector, events:UIControlEvents){
        nextKeyboardButton.addTarget(target, action: action, forControlEvents: events)
    }
}
