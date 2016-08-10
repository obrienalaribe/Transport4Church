//
//  TrackPickupController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 10/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit


class TrackPickupController: UIViewController {
    var count = "10"
    var displayTimeLabel: UILabel!
    var messageLabel : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 40))
        label.textAlignment = NSTextAlignment.Center
        label.text = "The church bus will soon arrive"
        label.textColor = .blackColor()
        label.backgroundColor = .blueColor()
        return label
    }()
    
    var startTime : NSTimeInterval!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Track Pickup"
        
        displayTimeLabel = UILabel()
        displayTimeLabel.font = UIFont.boldSystemFontOfSize(30)
        
        messageLabel = UILabel()
        view.addSubview(messageLabel)
        let margins = view.layoutMarginsGuide

        messageLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        messageLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        messageLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor,
                                                                constant: 8.0).active = true
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        
        view.backgroundColor = .whiteColor()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        startTime = NSTimeInterval()
        
        startTime = NSDate.timeIntervalSinceReferenceDate()
 
        view.addSubview(displayTimeLabel)
        displayTimeLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        displayTimeLabel.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        displayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func updateTime() {
        
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        displayTimeLabel.text = ("\(strMinutes):\(strSeconds)")
    }
}
