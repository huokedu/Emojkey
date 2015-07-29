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
    
    private let nextKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    private var imageIndex = 0
    private let maxImages  = 7
    private let emojImage = UIImageView()
    private let emojWidth:CGFloat  = 339.0
    private let emojHeight:CGFloat = 107.5
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        print("Bottom view started");
        self.userInteractionEnabled = true;
        
        //self.nextKeyboardButton.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        
        
        if let buttonIcon = UIImage(named: "keyboardswitch") {
            nextKeyboardButton.frame = CGRectMake(10.0, frame.height-30.0, 40, frame.height)
            nextKeyboardButton.setBackgroundImage(buttonIcon, forState: UIControlState.Normal)
        }
        
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let x:CGFloat = (frame.width - emojWidth)/2
        let y:CGFloat = (frame.height - emojHeight)/2
        emojImage.frame = CGRectMake(x, y, emojWidth, emojHeight)
        updateImage()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        
        
        self.addSubview(self.nextKeyboardButton)
        self.addSubview(emojImage)
        //var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)
        //var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        //self.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
        
    }
    
    func currentImage()->UIImage{
        return emojImage.image!
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextButtonTarget(target:AnyObject, action:Selector, events:UIControlEvents){
        nextKeyboardButton.addTarget(target, action: action, forControlEvents: events)
    }
    
    private func updateImage(){
        emojImage.image = UIImage(named: "Mouth\(imageIndex+1)")
        print("Loaded Mouth\(imageIndex+1)\n")
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right :
                println("User swiped right")
                // decrease index first
                imageIndex--
                // check if index is in range
                if imageIndex < 0 {
                    imageIndex = maxImages - 1
                }
                updateImage()
                
                
            case UISwipeGestureRecognizerDirection.Left:
                println("User swiped Left")
                
                // increase index first
                
                imageIndex++
                
                // check if index is in range
                
                if imageIndex >= maxImages {
                    
                    imageIndex = 0
                    
                }
                updateImage()
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
}
