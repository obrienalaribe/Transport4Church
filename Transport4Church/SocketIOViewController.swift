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
    let socket = SocketIOClient(socketURL: URL(string:"https://t4cserver.herokuapp.com/")!)

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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
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
