//
//  TopEmojiView.swift
//  EmojKey
//
//  Created by Matthew Carlson on 7/27/15.
//  Copyright (c) 2015 Matthew Carlson. All rights reserved.
//

import Foundation
import UIKit

class TopEmojiView: UIView{
    
    private let backKeyboardButton = UIButton.buttonWithType(.Custom) as! UIButton
    private var imageIndex = 0
    private let maxImages  = 8
    private let emojImage  = UIImageView()
    private let emojWidth:CGFloat  = 339.0
    private let emojHeight:CGFloat = 90.5
    private let emojAnim  = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        print("Top view started");
        self.userInteractionEnabled = true;
        
        if let buttonIcon = UIImage(named: "backspace") {
            backKeyboardButton.frame = CGRectMake(frame.width-40.0, 10.0, frame.width-10, 33.0)
            backKeyboardButton.setBackgroundImage(buttonIcon, forState: UIControlState.Normal)
        }
        
        backKeyboardButton.sizeToFit()
        backKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(self.backKeyboardButton)
        
        let x:CGFloat = (frame.width - emojWidth)/2
        let y:CGFloat = (frame.height - emojHeight)/2
        emojImage.frame = CGRectMake(x, y, emojWidth, emojHeight)
        emojAnim.frame = emojImage.frame
        emojAnim.hidden = true
        updateImage()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(swipeLeft)
        
        self.addSubview(emojImage)
        self.addSubview(emojAnim)
    }
    
    func currentImage()->UIImage{
        return emojImage.image!
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateImage(){
        emojAnim.frame = emojImage.frame
        emojAnim.image = emojImage.image
        emojImage.image = UIImage(named: "Eyes\(imageIndex+1)")
        print("Loaded Mouth\(imageIndex+1)\n")
    }
    
    func backButtonTarget(target:AnyObject, action:Selector, events:UIControlEvents){
        backKeyboardButton.addTarget(target, action: action, forControlEvents: events)
    }
    
    func moveImages(#goleft:Bool){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.emojAnim.hidden = true
        })
        emojAnim.hidden = false
        emojImage.hidden = false
        var newX:CGFloat = 400;
        if (goleft){
            newX = -400;
        }
        
        var toPoint: CGPoint = CGPointMake(newX, 0.0)
        var fromPoint : CGPoint = CGPointZero
        
        var movement = CABasicAnimation(keyPath: "position")
        movement.additive = true
        movement.fromValue =  NSValue(CGPoint: fromPoint)
        movement.toValue =  NSValue(CGPoint: toPoint)
        movement.duration = 0.2
        
        emojAnim.layer.addAnimation(movement, forKey: "move")
        CATransaction.commit()
        
        var newX2:CGFloat = newX * -1;
        
        fromPoint = CGPointMake(newX2, 0.0)
        toPoint   = CGPointZero
        
        var movement2 = CABasicAnimation(keyPath: "position")
        movement2.additive = true
        movement2.fromValue =  NSValue(CGPoint: fromPoint)
        movement2.toValue =  NSValue(CGPoint: toPoint)
        movement2.duration = movement.duration
        
        
        emojImage.layer.addAnimation(movement2, forKey: "move")
     
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
                moveImages(goleft: false)
                
                
            case UISwipeGestureRecognizerDirection.Left:
                println("User swiped Left")
                
                // increase index first
                
                imageIndex++
                
                // check if index is in range
                
                if imageIndex >= maxImages {
                    
                    imageIndex = 0
                    
                }
                updateImage()
                moveImages(goleft: true)
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
}
