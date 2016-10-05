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
    let socket = SocketIOClient(socketURL: NSURL(string:"https://t4cserver.herokuapp.com/")!)

    let update : UIButton = {
        let btn = UIButton()
        btn.setTitle("Update Location", forState: .Normal)
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.darkGrayColor().CGColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        btn.backgroundColor = UIColor.whiteColor()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(update)
        update.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        update.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
        update.translatesAutoresizingMaskIntoConstraints = false
        update.addTarget(self, action: "emitUpdate", forControlEvents: .TouchUpInside)
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
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
