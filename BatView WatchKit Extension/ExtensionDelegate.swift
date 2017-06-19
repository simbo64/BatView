//
//  ExtensionDelegate.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 05/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import WatchKit
import ClockKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let defaults = UserDefaults.standard
    
    func applicationDidFinishLaunching() {
        print(Functions().getTimeForLog(),"ExtensionDelegate: applicationDidFinishLaunching")
        readDeviceDataWatchOS()
        WCManager().setupWCSession()
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        print(Functions().getTimeForLog(),"ExtensionDelegate: applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        print(Functions().getTimeForLog(),"ExtensionDelegate: applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        print(Functions().getTimeForLog(),"ExtensionDelegate: handleBackgroundTasks")
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 60 * 60), userInfo: nil) { (error: Error?) in
                    if let error = error {
                        print("Error occurred while scheduling background refresh: \(error.localizedDescription)")
                    }
                }
                
                /*let complicationServer = CLKComplicationServer.sharedInstance()
                for complication in activeComplications {
                    complicationServer.reloadTimelineForComplication(complication)
                }*/
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    func readDeviceDataWatchOS() {
        print(WKInterfaceDevice.current().name)
        print(WKInterfaceDevice.current().model,WKInterfaceDevice.current().systemName,WKInterfaceDevice.current().systemVersion)
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        print(WKInterfaceDevice.current().batteryState.rawValue,WKInterfaceDevice.current().batteryLevel)
        print(WKInterfaceDevice.current().waterResistanceRating.rawValue)
        if WKInterfaceDevice.current().waterResistanceRating.rawValue == 1 {
            print(Functions().getTimeForLog(),"Apple Watch Series 2")
            defaults.set(true, forKey: "CBEnabled")
        }
        else {
            print(Functions().getTimeForLog(),"Apple Watch Series 1/0")
            // Disable CoreBluetooth device pairing
            defaults.set(false, forKey: "CBEnabled")
        }
        print("TEST AFTER SET UserDefaults:", defaults.bool(forKey: "CBEnabled"))    }

}
