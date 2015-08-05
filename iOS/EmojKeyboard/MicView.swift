//
//  MicView.swift
//  EmojKey
//
//  Created by Matthew Carlson on 7/30/15.
//  Copyright (c) 2015 Matthew Carlson. All rights reserved.
//

import Foundation

class MicView:UIView{
    
    //private NSMutableString* textOnScreen;
    //private DataRecognitionClient* dataClient;
    //private MicrophoneRecognitionClient* micClient;
    
    //private let recoMode:SpeechRecognitionMode = SpeechRecognitionMode.ShortPhrase;
    private let isMicrophoneReco = true;
    private let isIntent = false;
    private let waitSeconds = 20 ;
    
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.backgroundColor = UIColor(white: 0.12, alpha: 0.6)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startListening(){
        hidden = false
    }
    
    func stopListening(){
        hidden = true
    }
    
    
    
}
