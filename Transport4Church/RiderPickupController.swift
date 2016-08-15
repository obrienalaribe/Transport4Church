//
//  PickupRiderController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Eureka
import GooglePlaces
import CoreLocation

class RiderPickupController: UIViewController {
    
    var mapView : GMSMapView!
    
    //http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift-2-ios-9/
    
    var locationTrackingLabel : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 40))
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    let mapPin : UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "map_pin")
        return view
    }()
    
    let brandLogo  : UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "brand_logo")
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    var pickupBtn : UIButton!
    
    var userLocationPermissionEnabled : Bool? = nil
    
    var userCoordinate: CLLocationCoordinate2D!
    var driverLocation : GMSMarker!
    
    var currentTrip : Trip?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height ))
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(12, maxZoom: 16)
        
        setUserLocationOnMap()
        
        view.addSubview(mapView)
        
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
        
        //observers
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleLocationAuthorizationState), name: UIApplicationWillEnterForegroundNotification, object: nil)

    }
    
    func setUserLocationOnMap(){
        let manager = CLLocationManager()
        manager.delegate = self
        
        if let location = manager.location {
            self.userCoordinate = location.coordinate
            self.userLocationPermissionEnabled = true
            mapView.camera = GMSCameraPosition.cameraWithLatitude(self.userCoordinate.latitude, longitude: self.userCoordinate.longitude, zoom: 14.0)
           
            mapView.animateToLocation(CLLocationCoordinate2D(latitude: self.userCoordinate.latitude, longitude: self.userCoordinate.longitude))
            
        }else{
            //            manager.requestWhenInUseAuthorization()
            self.userLocationPermissionEnabled = false
        }
        
       
    }
    
    private func setupLocationTrackingLabel() {
        let margins = view.layoutMarginsGuide
        view.addSubview(locationTrackingLabel)
        
        locationTrackingLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        locationTrackingLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        locationTrackingLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor,
                                                                constant: 8.0).active = true
        locationTrackingLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTrackingLabel.backgroundColor = .whiteColor()
        locationTrackingLabel.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                                   multiplier: 0.1).active = true
        locationTrackingLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: Selector("updateLocationAction:"))
        locationTrackingLabel.addGestureRecognizer(tap)
    }
    
    func updateLocationAction(sender:UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
        
    }
    
    private func setupMapPin(){
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mapPin.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -30).active = true
        mapPin.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPickupButton(){
        pickupBtn = UIButton()
        pickupBtn.userInteractionEnabled = false //disable till user location is determined
        pickupBtn.layer.cornerRadius = 12
        pickupBtn.setTitle("Pick me up", forState: .Normal)
        pickupBtn.backgroundColor = .purpleColor()
        pickupBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        mapView.addSubview(pickupBtn)
        
        pickupBtn.centerXAnchor.constraintEqualToAnchor(mapPin.centerXAnchor).active = true
        pickupBtn.centerYAnchor.constraintEqualToAnchor(mapPin.centerYAnchor, constant: -15).active = true
        pickupBtn.translatesAutoresizingMaskIntoConstraints = false
        
        pickupBtn.addTarget(self, action: "createPickupRequest", forControlEvents: .TouchUpInside)
        
    }
    
    func createPickupRequest() {
        let fakeUser = User(name: "John Okafor", gender: "Male", email: "john@gmail.com", role: .Rider)
        let rider = Rider(currentLocation: nil, destination: Address(), userDetails: fakeUser)
        //Make vars above instance variables
        
        self.currentTrip = Trip(rider: rider)
        
//        self.currentTrip!.address("test")
//        self.currentTrip!.coordinates(mapView.camera.target)
        navigationController?.pushViewController(ConfirmPickupFormController(trip: self.currentTrip), animated: true)
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
//        handleLocationAuthorizationState()
        
       
        
    }
    
    func handleLocationAuthorizationState(){
        if !userLocationPermissionEnabled! {
            var alertController = UIAlertController (title: "Location Required", message: "You have disabled location usage. Kindly visit your settings and turn it on ", preferredStyle: .Alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            setUserLocationOnMap()
            print("view loaded from background ")

        }
        
        
        
    }
    
       
}


