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
    static let maxImages  = 10
    private let emojImage  = UIImageView()
    private let emojWidth:CGFloat  = 339.0
    private let emojHeight:CGFloat = 90.5
    private let emojAnim  = UIImageView()
    private var currentUImage = UIImage();
    private var animatedEmoj = [UIImage?](count:maxImages, repeatedValue:nil)
    
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
        self.sendSubviewToBack(emojImage)
        
        loadAnimations()
    }
    
    func loadAnimations(){
        backgroundThread(background: {
                // Your function here to run in the background
                for i in 0...TopEmojiView.maxImages-1{
                    print("Loaded GIF \(i)\t")
                    self.animatedEmoj[i] = self.loadAnimatedGIF(i)
                }
            },
            completion: {
                // A function to run in the foreground when the background thread is complete
                print("Loaded all animated assets\n")
        });
    }
    
    func loadAnimatedGIF(i:Int)->UIImage?{
        let names = ["","","angry","","suprised","","","","","","",""]
        if (names[i] == ""){
            return nil
        }
        let url = NSBundle.mainBundle().URLForResource(names[i], withExtension: "gif")
        let GIF = UIImage.animatedImageWithAnimatedGIFURL(url)
        if  GIF == nil {
            print("The gif: \(names[i]) doesn't exist\n")
            return nil
        }
        else{
            print("Yay! The gif: \(names[i]) exist\n")
            
        }
        
        return GIF
        
    }
    
    func currentImage()->UIImage{
        return currentUImage
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateImage(){
        emojAnim.frame = emojImage.frame
        emojAnim.image = emojImage.image
        emojImage.image = UIImage(named: "Eyes\(imageIndex+1)")
        currentUImage = emojImage.image!
        print("Loaded Mouth\(imageIndex+1)\n")
    }
    
    private func finishedTransition(){
        self.emojAnim.hidden = true
        if (self.animatedEmoj[imageIndex] != nil){
            print("Using animation on \(imageIndex)")
            self.emojImage.image = animatedEmoj[imageIndex]
            self.emojImage.startAnimating()
        }
        
    }
    private func startTransition(){
        emojAnim.hidden = false
        emojImage.hidden = false
        self.emojImage.stopAnimating()
    }
    
    func backButtonTarget(target:AnyObject, action:Selector, events:UIControlEvents){
        backKeyboardButton.addTarget(target, action: action, forControlEvents: events)
    }
    
    func moveImages(#goleft:Bool){
        startTransition();
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(finishedTransition)
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
                    imageIndex = TopEmojiView.maxImages - 1
                }
                updateImage()
                moveImages(goleft: false)
                
                
            case UISwipeGestureRecognizerDirection.Left:
                println("User swiped Left")
                
                // increase index first
                
                imageIndex++
                
                // check if index is in range
                
                if imageIndex >= TopEmojiView.maxImages {
                    
                    imageIndex = 0
                    
                }
                updateImage()
                moveImages(goleft: true)
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            if(background != nil){ background!(); }
            
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
}
