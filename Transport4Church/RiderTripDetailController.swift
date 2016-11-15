//
//  RiderRequestViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

protocol TripStateControllerDelegate {
    func riderWillCancelTrip()
    func driverDidCancelTrip()
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0)
        label.text = "Request Sent"
        label.textAlignment = .center
        return label
    }()
    
    let infoDetailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red:0.76, green:0.80, blue:0.78, alpha:1.0)
        label.text = "* The driver will soon be on their way *"
        label.textAlignment = .center
        label.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:0.6)
        return label
    }()
    
    let cancelPickupBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Contact Driver", for: UIControlState())
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        btn.layer.zPosition = 2
        return btn
    }()
    
  
    var originLabel : UILabel!
    var destinationLabel : UILabel!

    var delegate: TripStateControllerDelegate!
    
    var trip : Trip
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        view.addSubview(container)
        
        let margins = view.layoutMarginsGuide

        //setup middle container
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        container.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.white
        container.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                                   multiplier: 0.5).isActive = true

        //setup info line
        container.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
      
        //setup info detail line
        container.addSubview(infoDetailLabel)
        infoDetailLabel.topAnchor.constraint(equalTo: infoLabel.topAnchor, constant: 30).isActive = true
        infoDetailLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        infoDetailLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        infoDetailLabel.translatesAutoresizingMaskIntoConstraints = false

        //setup trip details container
        container.addSubview(tripDetails)
        tripDetails.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        tripDetails.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10).isActive = true

        tripDetails.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        tripDetails.translatesAutoresizingMaskIntoConstraints = false
        tripDetails.backgroundColor = UIColor.white
        tripDetails.heightAnchor.constraint(equalTo: container.heightAnchor,
                                                         multiplier: 0.5).isActive = true
//        tripDetails.backgroundColor = .redColor()
   

        //setup origin line
        let originView = UIView()
        tripDetails.addSubview(originView)
        
        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: originView)
        tripDetails.addConstraintsWithFormat("V:|-10-[v0(35)]", views: originView)
        
        createLineView(originView, leftTitle: "Origin", rightTitle: self.trip.rider.address.streetName!)


        //setup destination line
        let destinationView = UIView()

        tripDetails.addSubview(destinationView)

        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: destinationView)
        tripDetails.addConstraintsWithFormat("V:|-50-[v0(35)]", views: destinationView)

        let destination : Church =  ChurchRepo.churchCacheById[self.trip.destination.objectId!]!
        createLineView(destinationView, leftTitle: "Destination", rightTitle: destination.name!)
       
        
        //setup pickup time line
        let timeView = UIView()
        tripDetails.addSubview(timeView)
        
        tripDetails.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: timeView)
        tripDetails.addConstraintsWithFormat("V:|-90-[v0(35)]", views: timeView)
        
        let dateArr = (Helper.convertDateToString(trip.pickupTime)).characters.split{$0 == ","}.map(String.init)

        createLineView(timeView, leftTitle: "Pickup time", rightTitle: ("\(dateArr.first!) \(dateArr.last!)"))
        
        //setup cancel button
    
        container.addSubview(cancelPickupBtn)
        cancelPickupBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        container.addConstraintsWithFormat("V:[v0(60)]", views: cancelPickupBtn)
        container.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: cancelPickupBtn)

        cancelPickupBtn.addTarget(self, action: #selector(RiderTripDetailController.cancelRequest), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    fileprivate func createLineView(_ lineView: UIView, leftTitle: String, rightTitle: String){
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
        self.delegate.riderWillCancelTrip()
    }
    
    func createLabel(_ title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        label.text = title
        label.textAlignment = .left
        label.backgroundColor = UIColor(red:0.99, green:0.99, blue:1, alpha:1.0)
        return label
    }
}
