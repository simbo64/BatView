//
//  WCManager.swift
//  BatView
//
//  Created by Simon Edwardes on 15/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

class WCManager: NSObject, WCSessionDelegate{
   
    var session : WCSession?
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print(Functions().getTimeForLog(),"sessionWatchStateDidChange",session)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(Functions().getTimeForLog(),"USER HAS CHANGED WATCH....activationDidCompleteWith", session)
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        readWatchMessage(dictionary: message as NSDictionary)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let deviceCountPaired = 0
        let dictionary = ["CurrentDate":Date(),"iPhoneBatteryLevel":Double(UIDevice.current.batteryLevel),"iPhoneBatteryState":Double(UIDevice.current.batteryState.rawValue),"DevicesPairedCount":deviceCountPaired] as [String : Any]
        replyHandler(dictionary)
    }
    
    func readWatchMessage(dictionary: NSDictionary){
        let returnedKeys = dictionary.allKeys
        let watchMessageDate = dictionary["CurrentDate"] as? NSDate
        let watchBatteryState = dictionary["WatchBatteryState"] as? Double
        let watchBatteryLevel = dictionary["WatchBatteryLevel"] as? Double
        let watchPairedDevicesCount = dictionary["DevicesPairedCount"] as! Int
        print(Functions().getTimeForLog(),"Watch Battery:",watchBatteryLevel!, "All Keys:",returnedKeys)
    }
    
    func setupWCSession(){
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("sessionReachabilityDidChange")
    }
    
     func sessionDidBecomeInactive(_ session: WCSession){
        print("sessionDidBecomeInactive")
    }
    
     func sessionDidDeactivate(_ session: WCSession){
        print("sessionDidDeactivate")
    }
}
