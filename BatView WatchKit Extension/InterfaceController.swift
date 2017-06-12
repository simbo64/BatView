//
//  InterfaceController.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 05/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var watchBatteryPercentage: WKInterfaceLabel!
    @IBOutlet var watchBatteryOverlay: WKInterfaceGroup!
    @IBOutlet var watchBatteryUnderlay: WKInterfaceGroup!
    @IBOutlet var pairDeviceButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        defineUIElements()
        readDeviceData()
        
       // CoreBluetoothManager().initializeCB(runningInBackground: false)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear() {
        let currentBatteryValue = 85 //WKInterfaceDevice.current().batteryState.rawValue
        let batteryString = String(currentBatteryValue) + "%"
        self.watchBatteryPercentage.setText(batteryString)
        animate(withDuration: 2) {
            let overlayWidth = CGFloat(Double(currentBatteryValue)/100)*WKInterfaceDevice.current().screenBounds.width
            self.watchBatteryOverlay.setWidth(overlayWidth)
        }
        super.didAppear()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func readDeviceData() {
        print(WKInterfaceDevice.current().name)
        print(WKInterfaceDevice.current().model,WKInterfaceDevice.current().systemName,WKInterfaceDevice.current().systemVersion)
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        print(WKInterfaceDevice.current().batteryState.rawValue,WKInterfaceDevice.current().batteryLevel)
        print(WKInterfaceDevice.current().waterResistanceRating.rawValue)
        if WKInterfaceDevice.current().waterResistanceRating.rawValue == 1 {
            print("Apple Watch Series 2")
        }
        else {
            print("Apple Watch Series 1/0")
        }
    }
    
    func defineUIElements() {
        self.watchBatteryUnderlay.setWidth(WKInterfaceDevice.current().screenBounds.width)
        self.watchBatteryOverlay.setWidth(5)
    }
}
