//
//  KeyboardViewController.swift
//  EmojKeyboard
//
//  Created by Matthew Carlson on 7/27/15.
//  Copyright (c) 2015 Matthew Carlson. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var faceEmoji: UIImageView!
    
    var topView:TopEmojiView?
    var bottomView:BottomEmojiView?
    
    var currentColor = 0
    let colors = [UIColor.redColor(), UIColor.brownColor(), UIColor.blueColor(), UIColor.yellowColor()]

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 1.0, green: 0.772, blue: 0.3725, alpha: 1.0)
        
        
        // Perform custom UI setup here
        addKeyboardEmoji();
        addKeyboardButtons();
        
        //Setup gesture recognition
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)

    }
    
    override func viewDidAppear(animated: Bool) {
        setupKeyboardEmoji();
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        print("We just swiped up!");
        var proxy = textDocumentProxy as! UITextDocumentProxy
        
        proxy.insertText("Lolololol ")
        
    }
    
    func addKeyboardEmoji(){
        var toptouch = UITapGestureRecognizer(target:self, action:"touchAction:")
        var bottouch = UITapGestureRecognizer(target:self, action:"touchAction:")
        
        let topFrame = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 108.0)
        let botFrame = CGRect(x: 0.0, y: 108.0, width: 375.0, height: 108.0)
        print("\(topFrame)\n \(botFrame)")
        
        topView    = TopEmojiView(frame: topFrame)
        bottomView = BottomEmojiView(frame: botFrame);
        
        topView!.addGestureRecognizer(toptouch);
        bottomView!.addGestureRecognizer(bottouch);
        
        self.view.addSubview(topView!)
        self.view.addSubview(bottomView!)
        
    }
    
    func setupKeyboardEmoji(){
        print("\(view.frame.minX) x \(view.frame.minY)\n")
        print("\(view.frame.height) x \(view.frame.width)\n")
        let topFrame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height/2)
        let botFrame = CGRect(x: 0.0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height)
        
        topView!.frame = topFrame;
        bottomView!.frame = botFrame;
        
        topView!.layoutIfNeeded()
        bottomView!.layoutIfNeeded()
    }
    
    func addKeyboardButtons(){
        /*self.nextKeyboardButton = UIButton.buttonWithType(.System) as! UIButton
        
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])*/
        
        bottomView?.nextButtonTarget(self, action: "advanceToNextInputMode", events: .TouchUpInside)
    }
    
    func touchAction(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            print("Tapped");
            //changeColor(1);
        }
    }
    
    func changeColor(increment: Int){
        let inc = increment % colors.count;
        currentColor += inc;
        if (currentColor<0) {
            currentColor += colors.count;
        }
        else if (currentColor >= colors.count){
            currentColor -= colors.count;
        }
        self.view.backgroundColor = colors[currentColor];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as! UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        //self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
