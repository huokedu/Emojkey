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
    var currentColor = 0
    let colors = [UIColor.redColor(), UIColor.brownColor(), UIColor.blueColor(), UIColor.yellowColor()]

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup gesture recognition
        var touch = UITapGestureRecognizer(target:self, action:"touchAction:")
        self.inputView.addGestureRecognizer(touch)
        view.userInteractionEnabled = true;
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
    
        // Perform custom UI setup here
        addKeyboardButtons()
        addKeyboardEmoji();
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        print("We just swiped up!");
        var proxy = textDocumentProxy as! UITextDocumentProxy
        
        proxy.insertText("Lolololol ")
        
    }
    
    func touchAction() {
        print("Tapped with no info");
        changeColor(-1);
    }
    
    func addKeyboardEmoji(){
        let tempSmileImage = UIImage(named: "testSmile");
        
        self.faceEmoji = UIImageView(image: tempSmileImage!)
        
        self.view.addSubview(self.faceEmoji)
        
        let centerXConstr = NSLayoutConstraint(item: faceEmoji, attribute: .CenterX, relatedBy: .Equal, toItem:self.view, attribute: .CenterX, multiplier: 1.0, constant: 0.0);
        let centerYConstr = NSLayoutConstraint(item: faceEmoji, attribute: .CenterY, relatedBy: .Equal, toItem:self.view, attribute: .CenterY, multiplier: 1.0, constant: 0.0);
        let widthConstr   = NSLayoutConstraint(item: faceEmoji, attribute: .Width, relatedBy: .Equal, toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier:1.0, constant:300.0);
        let heightConstr  = NSLayoutConstraint(item: faceEmoji, attribute: .Height, relatedBy: .Equal, toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier:1.0, constant:300.0);
        self.view.addConstraints([widthConstr, heightConstr])
        self.view.addConstraints([centerXConstr, centerYConstr])
        
    }
    
    func addKeyboardButtons(){
        self.nextKeyboardButton = UIButton.buttonWithType(.System) as! UIButton
        
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -10.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
    
    func touchAction(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            print("Tapped");
            changeColor(1);
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
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
