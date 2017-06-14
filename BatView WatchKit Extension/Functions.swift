//
//  functions.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 13/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import Foundation

class Functions: NSObject{
    func getTimeForLog() -> (String) {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        let second = Calendar.current.component(.second, from: Date())
        let nanosecond = Double(Calendar.current.component(.nanosecond, from: Date()))
        let nanosecondInt = Int(nanosecond / 1000000)
        let timeString = String(hour) + ":" + String(minute) + " " + String(second) + "." + String(nanosecondInt) + " -->"
        return timeString
    }
}
