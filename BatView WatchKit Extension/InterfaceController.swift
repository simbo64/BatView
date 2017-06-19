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
    
    var viewContext = 0
    let defaults = UserDefaults.standard
    @IBOutlet var watchBatteryPercentage: WKInterfaceLabel!
    @IBOutlet var watchBatteryOverlay: WKInterfaceGroup!
    @IBOutlet var watchBatteryUnderlay: WKInterfaceGroup!
    @IBOutlet var pairDeviceButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        print(Functions().getTimeForLog(),"InterfaceController: awake")
        super.awake(withContext: context)
        defineUIElements()
        
        
       // CoreBluetoothManager().initializeCB(runningInBackground: false)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        if viewContext == 1 {
            viewContext = 0
            present()
        }
        print(Functions().getTimeForLog(),"InterfaceController: willActivate")
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didAppear() {
     print(Functions().getTimeForLog(),"InterfaceController: didAppear")
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
        print(Functions().getTimeForLog(),"InterfaceController: didDeactivate")
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func pairButtonPressed() {
        //present()
        displayInfoOnce()
    }
    @IBAction func tempSyncButton() {
        WCManager().updateDataWithiPhone()
    }
    
    func displayInfoOnce() {
        //if displaycount == 0 {
            let dismissAction = WKAlertAction(title: "Continue", style: .default, handler: {
                self.viewContext = 1
                
                //self.displaycount = 1
                //self.present()
                //self.presentController(withName: "PairInterfaceController", context: nil)
                //CoreBluetoothCentralManager().initializeCB(runningInBackground: false)
            })
            self.presentAlert(withTitle: "Pairing", message: "Hold your watch close to your iPhone or iPad with BatteryWatch open", preferredStyle: .alert, actions: [dismissAction])
        //}
       // else {
           // presentController(withName: "PairInterfaceController", context: nil)
           // CoreBluetoothCentralManager().initializeCB(runningInBackground: false)
        //}
    }
    
    func present(){
        presentController(withName: "PairInterfaceController", context: nil)
        CoreBluetoothCentralManager().initializeCB(runningInBackground: false)
    }
    func defineUIElements() {
        self.watchBatteryUnderlay.setWidth(WKInterfaceDevice.current().screenBounds.width)
        self.watchBatteryOverlay.setWidth(1)
        self.watchBatteryOverlay.setBackgroundColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
        if !defaults.bool(forKey: "CBEnabled"){
            pairDeviceButton.setHidden(true)
        }
        
    }
}
