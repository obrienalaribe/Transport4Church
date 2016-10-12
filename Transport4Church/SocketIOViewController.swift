//
//  SocketIOViewController.swift
//  Transport4Church
//
//  Created by mac on 9/25/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import SocketIO
import BRYXBanner
import Parse

class SocketIOViewController: UIViewController {
    let socket = SocketIOClient(socketURL: URL(string:"http://localhost:3000/")!)

    let update : UIButton = {
        let btn = UIButton()
        btn.setTitle("Update Location", for: UIControlState())
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(update)
        update.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        update.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        update.translatesAutoresizingMaskIntoConstraints = false
        update.addTarget(self, action: #selector(SocketIOViewController.emitUpdate), for: .touchUpInside)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addHandlers()
        socket.connect()
    }
    
    
    func addHandlers() {
        socket.on("driverLocationUpdateFor:ABC") {[weak self] data, ack in
            print("driver location update is \(data)")
            return
        }
        
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
           print("User connected successfully ...")
        }
        
//        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    func emitUpdate(){

        //CONNECT USER by userid
        socket.emit("connectUser", "ABC")
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let dataDictionary = ["userID": "ABC", "lat": "123", "long" : "345"]
            self.socket.emit("driverChangedLocation", dataDictionary)

        })

    func emitUpdate(){
        print("emitting ...")
       
        let googleMapsAppURL = URL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(googleMapsAppURL) {
            //Google maps exist on device
            let directionsRequest = "comgooglemaps-x-callback://" +
                "?daddr=ls42bb" + "&directionsmode=driving" +
            "&x-success=sourceapp://?resume=true&x-source=AirApp"
            
            let directionsURL = NSURL(string: directionsRequest)!
            UIApplication.shared.openURL(directionsURL as URL)
            
        } else {
            //Prompt to download Google maps
            let alertController = UIAlertController (title: "Download Google Maps", message: "Please download Google Maps to help you navigate to the rider's location", preferredStyle: .alert)
            
            let downloadAction = UIAlertAction(title: "Download", style: .default) { (_) -> Void in
                let googleMapsDownloadURL = URL(string: "itms://itunes.apple.com/us/app/google-maps-navigation-transit/id585027354")
                if UIApplication.shared.canOpenURL(googleMapsDownloadURL!) {
                    UIApplication.shared.openURL(googleMapsDownloadURL!)
                }
            }
            
    
            let cancelAction = UIAlertAction(title: "Exit", style: .default, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(downloadAction)
            
            present(alertController, animated: true, completion: nil)

        }
        
        }
    }

}
