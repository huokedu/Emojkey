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
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        print("Bottom view started");
        self.userInteractionEnabled = true;
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
