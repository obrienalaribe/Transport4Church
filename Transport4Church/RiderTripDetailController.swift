//
//  RiderRequestViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class RiderTripDetailController: UIViewController {

    let tripDetails: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        return view
    }()
    
    
    let cancelPickupBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel Request", forState: .Normal)
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.darkGrayColor().CGColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        btn.backgroundColor = UIColor.whiteColor()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.layer.zPosition = 2
        return btn
    }()
    
    
    var originLabel : UILabel!
    var destinationLabel : UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        view.addSubview(tripDetails)
        
        title = "Request"

        let margins = view.layoutMarginsGuide
//  
        
        tripDetails.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tripDetails.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true

        tripDetails.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
              tripDetails.translatesAutoresizingMaskIntoConstraints = false
        tripDetails.backgroundColor = .whiteColor()
        tripDetails.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                                   multiplier: 0.5).active = true
        
        let originView = UIView()
        originView.backgroundColor = UIColor.orangeColor()
        tripDetails.addSubview(originView)
        
        tripDetails.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: originView)
        tripDetails.addConstraintsWithFormat("V:|-10-[v0(60)]", views: originView)
        
        createLineView(originView, leftTitle: "Origin", rightTitle: "15-15 Walter Street")

        let destinationView = UIView()
        destinationView.backgroundColor = UIColor.orangeColor()
        tripDetails.addSubview(destinationView)

        tripDetails.addConstraintsWithFormat("H:|-20-[v0]-20-|", views: destinationView)
        tripDetails.addConstraintsWithFormat("V:|-70-[v0(60)]", views: destinationView)

        createLineView(destinationView, leftTitle: "Destin", rightTitle: "15-15 Walter Street")
       
    }
    
    func createLineView(lineView: UIView, leftTitle: String, rightTitle: String){
        let leftLabel = createLabel(leftTitle)
        let rightLabel = createLabel(rightTitle)
        
        lineView.addSubview(leftLabel)
        lineView.addSubview(rightLabel)
        
        let bottomBorderLine = UIView()
        lineView.addSubview(bottomBorderLine)
        
        bottomBorderLine.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        lineView.addConstraintsWithFormat("H:|[v0(80)]-10-[v1]|", views: leftLabel, rightLabel)
        lineView.addConstraintsWithFormat("H:|-90-[v0]|", views: bottomBorderLine)
        
        lineView.addConstraintsWithFormat("V:|[v0]|", views: leftLabel)
        lineView.addConstraintsWithFormat("V:|[v0]|", views: rightLabel)
        lineView.addConstraintsWithFormat("V:|-50-[v0(5)]", views: bottomBorderLine)
        

    }
    
    func showMenu() {
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.presentViewController(menuNavCtrl, animated: true, completion: nil)
    }
    
    
    func setupCancelPickupBtn(){
        view.addSubview(cancelPickupBtn)
        
        cancelPickupBtn.topAnchor.constraintEqualToAnchor(tripDetails.bottomAnchor, constant: 10).active = true
        
        cancelPickupBtn.leadingAnchor.constraintEqualToAnchor(tripDetails.leadingAnchor).active = true
        
        cancelPickupBtn.trailingAnchor.constraintEqualToAnchor(tripDetails.trailingAnchor).active = true
        
        cancelPickupBtn.translatesAutoresizingMaskIntoConstraints = false
        
        cancelPickupBtn.addTarget(self, action: #selector(RiderTripDetailController.cancelRequest), forControlEvents: .TouchUpInside)

    }
    
    func cancelRequest(){
        self.navigationController?.setViewControllers([RiderPickupController()], animated: true)
    }
    
    func createLabel(title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor.darkGrayColor()
        label.text = title
        label.textAlignment = .Left
        label.backgroundColor = UIColor.yellowColor()
        
        return label
    }
    
    

}


extension UIView {
    func addBottomBorder(parent: UIView, parentMargin : UILayoutGuide){
        
        let bottomBorderLine = UIView()
        parent.addSubview(bottomBorderLine)
        
        bottomBorderLine.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        bottomBorderLine.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        bottomBorderLine.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        parent.addConstraintsWithFormat("V:[v0]-10-[v1(1)]", views: self, bottomBorderLine)

    }
}
