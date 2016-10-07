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
    let socket = SocketIOClient(socketURL: URL(string:"https://t4cserver.herokuapp.com/")!)

    //This prevents others from using the default '()' initializer for this class.
    fileprivate override init() {
//        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
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
    
//    func sendDriverLocation(location: String, completionHandler: () -> Void) {
//        socket.emit("driverChangedLocation", location)
//        completionHandler()
//    }
//    
    func sendDriverLocation(_ location: CLLocation, completionHandler: () -> Void) {
        let locationDictionary = ["lat": location.coordinate.latitude, "long" : location.coordinate.longitude]
        socket.emit("driverChangedLocation", locationDictionary)
        completionHandler()
    }
    
    func getDriverLocation(_ completionHandler: @escaping (_ location: CLLocationCoordinate2D) -> Void) {
        socket.on("driverLocationUpdate") {(dataArray, socketAck) -> Void in
            let result = dataArray[0] as! Dictionary<String,Double>
            completionHandler(CLLocationCoordinate2D(latitude: result["lat"]!, longitude: result["long"]!))
        }
    }

}
