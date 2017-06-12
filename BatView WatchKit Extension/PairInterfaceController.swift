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
    
    var displaycount = 0
    @IBOutlet var cancelButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
         super.awake(withContext: context)
    }
    
    override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear() {
        displayInfoOnce()
        super.didAppear()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func displayInfoOnce() {
        if displaycount == 0 {
            let dismissAction = WKAlertAction(title: "Continue", style: .default, handler: {
                self.displaycount = 1
            })
            self.presentAlert(withTitle: "Pairing", message: "Hold your watch close to your iPhone or iPad with BatteryWatch open", preferredStyle: .alert, actions: [dismissAction])
        }
        else {
            CoreBluetoothManager().initializeCB(runningInBackground: false)
        }
    }
    
    @IBAction func cancelButtonPressed() {
        CoreBluetoothManager().cancelCBOperations()
        presentController(withName: "InterfaceController", context: nil)
    }
}
