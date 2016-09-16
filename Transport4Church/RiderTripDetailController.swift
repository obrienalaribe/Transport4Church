//
//  RiderRequestViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class RiderTripDetailController: UIViewController {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.image = UIImage(named: "user_male")
        imageView.layer.zPosition = 2
        return imageView
    }()
    
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
        
        title = "Request Sent"
        view.addSubview(profileImageView)
        view.backgroundColor = UIColor(white: 0.97, alpha: 1)
        
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        profileImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant:  -150).active = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tripDetails)
        
        let margins = view.layoutMarginsGuide
        
        tripDetails.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        tripDetails.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        tripDetails.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor,
                                                      constant: -30.0).active = true
        
        tripDetails.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor,
                                                         constant: -60.0).active = true
        
        tripDetails.backgroundColor = .whiteColor()
        
        tripDetails.translatesAutoresizingMaskIntoConstraints = false
        
        
        let profileContentMargin = tripDetails.layoutMarginsGuide
        
        setupFromLabel(profileContentMargin)
        setupCancelPickupBtn()
 
        
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(RiderPickupController.showMenu))
        menuBtn.tintColor = .blackColor()
        navigationItem.leftBarButtonItem = menuBtn
    }
    
    func showMenu() {
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.presentViewController(menuNavCtrl, animated: true, completion: nil)
    }
    
    
    func setupFromLabel(parentMargin : UILayoutGuide) {
        originLabel = createLabel("From: 12 Baddeley Close SG2 9SL")
        
        tripDetails.addSubview(originLabel)
        
        originLabel.topAnchor.constraintEqualToAnchor(tripDetails.topAnchor, constant: 40).active = true
        
        originLabel.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        originLabel.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        

        originLabel.addBottomBorder(tripDetails, parentMargin: parentMargin)
       

    }
    
    func setupToLabel(parentMargin : UILayoutGuide) {
        destinationLabel = createLabel("To: 12 Baddeley Close SG2 9SL")
        
        tripDetails.addSubview(originLabel)
        
        destinationLabel.topAnchor.constraintEqualToAnchor(tripDetails.topAnchor, constant: 40).active = true
        
        destinationLabel.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        destinationLabel.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        destinationLabel.addBottomBorder(originLabel, parentMargin: parentMargin)
        
        
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
    
    private func createLabel(title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor.darkGrayColor()
        label.text = title
        label.textAlignment = .Center
        
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
