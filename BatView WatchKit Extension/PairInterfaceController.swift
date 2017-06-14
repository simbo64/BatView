//
//  PairInterfaceController.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 11/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import WatchKit
import Foundation

class PairInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    @IBOutlet var group: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
        print(Functions().getTimeForLog(),"PairInterfaceController: awake")
         super.awake(withContext: context)
        
        image.setImageNamed("image")
        //image.startAnimatingWithImages(in: NSMakeRange(0, 21), duration: 1, repeatCount: 1)
        image.startAnimating()
    }
    
    override func willActivate() {
        print(Functions().getTimeForLog(),"PairInterfaceController: willActivate")
        
        WKExtension.shared().isAutorotating = true
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didAppear() {
        print(Functions().getTimeForLog(),"PairInterfaceController: didAppear")
        WKInterfaceDevice.current().play(.start)
        //WKInterfaceDevice.current().play(.success)
        
        
        
        super.didAppear()
    }
    
    override func didDeactivate() {
        print(Functions().getTimeForLog(),"PairInterfaceController: didDeactivate")
        WKExtension.shared().isAutorotating = false
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func willDisappear() {
        print(Functions().getTimeForLog(),"PairInterfaceController: willDisappear")
        //CoreBluetoothManager().cancelCBOperations()
        super.willDisappear()
    }
    
    
}
