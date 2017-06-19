//
//  AppDelegate.swift
//  BatView
//
//  Created by Simon Edwardes on 05/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//
import WatchConnectivity
import UIKit
import WatchKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    var window: UIWindow?
    var session : WCSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        readDeviceDataiOS()
        
        if WCSession.isSupported(){
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func readDeviceDataiOS() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        print(UIDevice.current.batteryLevel, UIDevice.current.batteryState)
        print(UIDevice.current.name, UIDevice.current.systemName, UIDevice.current.systemVersion, UIDevice.current.model)
    }
    
    //////////////// WATCH CONNECTIVITY IMPLEMENTATION ////////////////
    func sessionWatchStateDidChange(_ session: WCSession) {
        print(Functions().getTimeForLog(),"sessionWatchStateDidChange",session)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(Functions().getTimeForLog(),"USER HAS CHANGED WATCH....activationDidCompleteWith", session)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // Read Message
        readWatchMessage(dictionary: message as NSDictionary)
        // Reply To Message
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
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("sessionReachabilityDidChange")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession){
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession){
        print("sessionDidDeactivate")
    }
    //////////////// WATCH CONNECTIVITY IMPLEMENTATION END ////////////////
}

