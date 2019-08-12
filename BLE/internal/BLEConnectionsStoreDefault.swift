//
//  BLEConnectionsStoreDefault.swift
//  BLE
//
//  Created by  Sergey Dolin on 11/08/2019.
//  Copyright © 2019  Sergey Dolin. All rights reserved.
//

import CoreBluetooth
import Foundation

class BLEConnectionsStoreDefault: BLEConnectionsStoreInterface {

    
    let connectionFactory: BLEConnectionFactoryInterface
    let manager: CBCentralManager
    let peripheralObservablesFactory: BLEPeripheralObservablesFactoryInterface

    var _connectionsControl: BLEConnectionsControlInterface?
    var map: [String: BLEConnectionInterface] = [:]

    init(
        connectionFactory: BLEConnectionFactoryInterface,
        manager: CBCentralManager,
        peripheralObservablesFactory: BLEPeripheralObservablesFactoryInterface) {
        self.connectionFactory = connectionFactory
        self.peripheralObservablesFactory = peripheralObservablesFactory
        self.manager = manager
    }
    
    var connectionsControl: BLEConnectionsControlInterface {
        get {
            // must be set.
            // the ugly solution of cycle dependecy
            // connections <- store <- connectionsControl <- connections
            //   maybe i rethink it someday
            return _connectionsControl!
        }
    }
    
    func get(id: String) -> BLEConnectionInterface? {
        return map[id]
    }
    
    func getOrMake(id: String) -> BLEConnectionInterface {
        if map[id] == nil || !map[id]!.isConnected {
             map[id] = connectionFactory.connection(
                connectionsControl: connectionsControl,
                manager: manager,
                peripheralObservablesFactory: peripheralObservablesFactory,
                id: id)
        }
        return map[id]!
    }
    
    func setConnectionsControl(connectionsControl: BLEConnectionsControlInterface) {
        _connectionsControl = connectionsControl
    }
}
