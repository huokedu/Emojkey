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
    
    private var imageIndex = 0
    private let maxImages  = 8
    private let emojImage  = UIImageView()
    private let emojWidth:CGFloat  = 339.0
    private let emojHeight:CGFloat = 90.5
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        print("Top view started");
        self.userInteractionEnabled = true;
        
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
        
        self.addSubview(emojImage)
    }
    
    func currentImage()->UIImage{
        return emojImage.image!
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateImage(){
        emojImage.image = UIImage(named: "Eyes\(imageIndex+1)")
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
