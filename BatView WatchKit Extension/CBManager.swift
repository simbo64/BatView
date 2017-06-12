//
//  CBManager.swift
//  BatView WatchKit Extension
//
//  Created by Simon Edwardes on 09/06/2017.
//  Copyright © 2017 Simon Edwardes. All rights reserved.
//

import Foundation
import CoreBluetooth

class CoreBluetoothManager: NSObject, CBCentralManagerDelegate {
    
    var manager:CBCentralManager!
    var mainCharacteristic:CBCharacteristic? = nil
    let BAT_SERVICE_UUID = CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
    @available(watchOSApplicationExtension 2.0, *)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central)
    }
    
    func reconnectCBDevice (runningInBackground: Bool){
        // No need to scan for a peripheral for reconnect
        // let identifier = UUID()
        // let peripherals = manager.retrievePeripherals(withIdentifiers: [UUID])
        // central.connect(peripheralss[0])
    }
    
    func initializeCB (runningInBackground: Bool){
        // CB STEP ONE
        manager = CBCentralManager(delegate: self, queue: nil)
        if manager!.state == CBManagerState.poweredOn {
            manager?.scanForPeripherals(withServices: [BAT_SERVICE_UUID], options:nil)
        }
        else {
            print("Bluetooth switched off or disabled")
        }
    }
    
    // CB STEP TWO
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if RSSI.intValue > -10 || RSSI.intValue < -22 {
            print("Low signal peripheral discovered:",peripheral.name!)
            return
        }
        print("Valid peripheral discovered:",peripheral.name!)
        
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
        if device?.contains("DEVICE_NAME") == true {
            //self.peripheral = peripheral
            //self.peripheral.delegate = self
            manager.stopScan()
            // Check if we have seen peripheral before and then connect
            manager?.connect(peripheral, options: nil) // Connect options required?
        }
    }
    
    // CB STEP THREE
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(peripheral.name!,"connected")
        peripheral.discoverServices(nil)
        // Potential peripheral details
        //peripheral.identifier
        //peripheral.description
        //peripheral.name
        //peripheral.readRSSI() // Possibly wont work from central?
        //peripheral.state
        //peripheral.canSendWriteWithoutResponse
    }
    
    // CB STEP FOUR
    func peripheral(peripheral: CBPeripheral,didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            if service.uuid == BAT_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil,for: thisService)
            }
        }
    }
    
    // CB STEP FIVE
    func peripheral(peripheral: CBPeripheral,didDiscoverCharacteristicsForService service: CBService,error: NSError?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            if thisCharacteristic.uuid == BAT_SERVICE_UUID {
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
    // CB STEP SIX
    func peripheral(peripheral: CBPeripheral,didUpdateValueForCharacteristic characteristic: CBCharacteristic,error: NSError?) {
        if characteristic.uuid == BAT_SERVICE_UUID {
            print("didUpdateValueForCharacteristic:",characteristic.value! as NSData)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("didDisconnectPeripheral:",error!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("didFailToConnect:",error!)
    }
    
    //func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
     //   print("willRestoreState")
    //}
    
    func cancelCBOperations () {
        print("CoreBluetooth Operations Stopped")
        if manager.isScanning == true {
            manager.stopScan()
        }
    }
    
}
