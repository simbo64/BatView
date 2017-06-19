//
//  WCManager.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 15/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

class WCManager: NSObject, WCSessionDelegate{
    
    var session : WCSession?
    
    //@available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(Functions().getTimeForLog(),"USER HAS CHANGED WATCH....activationDidCompleteWith", session)
    }
    
    func updateDataWithiPhone(){
        //setupWCSession()
        let deviceCountPaired = 0
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        let dictionary = ["CurrentDate":Date(),"WatchBatteryLevel":Double(WKInterfaceDevice.current().batteryLevel),"WatchBatteryState":Double(WKInterfaceDevice.current().batteryState.rawValue),"DevicesPairedCount":deviceCountPaired] as [String : Any]
        //if session!.isReachable {
            print(Functions().getTimeForLog(),"updateDataWithiPhone, sendMessage")
            session?.sendMessage(dictionary, replyHandler: { (result) -> Void in
                let returnedKeys = result.keys
                let iPhoneBattery = dictionary["iPhoneBatteryLevel"] as? Double
                print(Functions().getTimeForLog(),"iPhone Battery:",iPhoneBattery!, "All Keys:",returnedKeys)
                // TODO: Handle your data from the iPhone
            }, errorHandler: { (error) -> Void in
                // TODO: Handle error - iPhone many not be reachable
            })
       /* }
        else{
            print(Functions().getTimeForLog(),"WCSession Unreachable")
        }*/
    }
    
    func setupWCSession(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print(session)
    }
    
    /* IOS ONLY
    func sessionDidBecomeInactive(_ session: WCSession){}
    func sessionDidDeactivate(_ session: WCSession){}*/
}
