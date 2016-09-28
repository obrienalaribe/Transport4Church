//
//  SocketIOManager.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 28/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    let socket = SocketIOClient(socketURL: NSURL(string:"https://t4cserver.herokuapp.com/")!)

    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    func establishConnection() {
        print("Establishing socket connection ... ")
        socket.connect()
    }
    
    
    func closeConnection() {
        print("Disconnecting socket connection ... ")
        socket.disconnect()
    }    
    
    func addHandlers() -> Void {
        
    }
    func sendDriverLocation(location: String, completionHandler: () -> Void) {
        socket.emit("driverChangedLocation", location)
        completionHandler()
    }
    
    
    func getDriverLocation(completionHandler: (locationInfo: [String: AnyObject]) -> Void) {
        socket.on("driverLocationUpdate") {(dataArray, socketAck) -> Void in
            var locationDictionary = [String: AnyObject]()
            locationDictionary["coord"] = dataArray[0] as! String
            completionHandler(locationInfo: locationDictionary)
        }
    }

}