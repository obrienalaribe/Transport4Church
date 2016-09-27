//
//  RiderRequestViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

protocol RiderTripDetailControllerDelegate {
    func riderDidCancelTrip()
}

class RiderTripDetailController: UIViewController {
    
    let tripDetails: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        return view
    }()
    
    let container: UIView = {
        let view = UIView()
        return view
    }()
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0)
        label.text = "Request Sent"
        label.textAlignment = .Center
        return label
    }()
    
    let infoDetailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        label.textColor = UIColor(red:0.76, green:0.80, blue:0.78, alpha:1.0)
        label.text = "* The driver will soon be on their way *"
        label.textAlignment = .Center
        label.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:0.6)
        return label
    }()
    
    let cancelPickupBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel Request", forState: .Normal)
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).CGColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        btn.backgroundColor = UIColor.whiteColor()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.layer.zPosition = 2
        return btn
    }()
    
    
    var originLabel : UILabel!
    var destinationLabel : UILabel!

    var delegate: RiderTripDetailControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        view.addSubview(container)
        
        let margins = view.layoutMarginsGuide

        //setup middle container
        container.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        container.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true

        container.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .whiteColor()
        container.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                                   multiplier: 0.5).active = true

        //setup info line
        container.addSubview(infoLabel)
        infoLabel.topAnchor.constraintEqualToAnchor(container.topAnchor, constant: 5).active = true
        infoLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
        infoLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //setup info detail line
        container.addSubview(infoDetailLabel)
        infoDetailLabel.topAnchor.constraintEqualToAnchor(infoLabel.topAnchor, constant: 30).active = true
        infoDetailLabel.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
        infoDetailLabel.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
        infoDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        //setup trip details container
        container.addSubview(tripDetails)
        tripDetails.centerXAnchor.constraintEqualToAnchor(container.centerXAnchor).active = true
        tripDetails.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor, constant: -10).active = true

        tripDetails.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
        tripDetails.translatesAutoresizingMaskIntoConstraints = false
        tripDetails.backgroundColor = .whiteColor()
        tripDetails.heightAnchor.constraintEqualToAnchor(container.heightAnchor,
                                                         multiplier: 0.5).active = true
//        tripDetails.backgroundColor = .redColor()
   

        //setup origin line
        let originView = UIView()
        tripDetails.addSubview(originView)
        
        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: originView)
        tripDetails.addConstraintsWithFormat("V:|-10-[v0(35)]", views: originView)
        
        createLineView(originView, leftTitle: "Origin", rightTitle: "15-15 Walter Street")

        //setup destination line
        let destinationView = UIView()

        tripDetails.addSubview(destinationView)

        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: destinationView)
        tripDetails.addConstraintsWithFormat("V:|-50-[v0(35)]", views: destinationView)

        createLineView(destinationView, leftTitle: "Destination", rightTitle: "15-15 Walter Street")
       
        //setup pickup time line
        let timeView = UIView()
        tripDetails.addSubview(timeView)
        
        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: timeView)
        tripDetails.addConstraintsWithFormat("V:|-90-[v0(35)]", views: timeView)
        
        createLineView(timeView, leftTitle: "Pickup time", rightTitle: Helper.convertDateToString(NSDate()))
        
        //setup cancel button
    
        container.addSubview(cancelPickupBtn)
        cancelPickupBtn.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor, constant: -10).active = true
        container.addConstraintsWithFormat("V:[v0(60)]", views: cancelPickupBtn)
        container.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: cancelPickupBtn)

        cancelPickupBtn.addTarget(self, action: #selector(RiderTripDetailController.cancelRequest), forControlEvents: .TouchUpInside)
    }
    
    private func createLineView(lineView: UIView, leftTitle: String, rightTitle: String){
        let leftLabel = createLabel(leftTitle)
        let rightLabel = createLabel(rightTitle)
        
        lineView.addSubview(leftLabel)
        lineView.addSubview(rightLabel)
        
        let bottomBorderLine = UIView()
        lineView.addSubview(bottomBorderLine)
        
        bottomBorderLine.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        
        lineView.addConstraintsWithFormat("H:|[v0(105)]-2-[v1]|", views: leftLabel, rightLabel)
        lineView.addConstraintsWithFormat("H:|-108-[v0]|", views: bottomBorderLine)
        
        lineView.addConstraintsWithFormat("V:|[v0]|", views: leftLabel)
        lineView.addConstraintsWithFormat("V:|[v0]|", views: rightLabel)
        lineView.addConstraintsWithFormat("V:|-32-[v0(3)]", views: bottomBorderLine)
        
    }

    
    func cancelRequest(){        
        self.dismissViewControllerAnimated(true) {
            self.delegate.riderDidCancelTrip()
        }
    }
    
    func createLabel(title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor.darkGrayColor()
        label.text = title
        label.textAlignment = .Left
        label.backgroundColor = UIColor(red:0.99, green:0.99, blue:1, alpha:1.0)
        return label
    }
}
