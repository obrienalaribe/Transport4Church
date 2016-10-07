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
    
    
//    func addHandlers() {
//        socket?.on("driverLocationUpdate") {[weak self] data, ack in
//            print("driver location update is \(data)")
//            return
//        }
//        socket?.onAny {print("Got event: \($0.event), with items: \($0.items)")}
//    }
    
    func emitUpdate(){
        print("emitting ...")
       
        

    }
    
    
}
