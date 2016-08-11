//
//  PickupRiderController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Eureka
import FontAwesome_swift
import GooglePlaces

class PickupRiderController: UIViewController, GMSMapViewDelegate{

    var mapView : GMSMapView!

   //API Key : AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck
    
    // Server Key : AIzaSyBGSay353rsnXZ14dvFomQLiLaVv9CHiCU

    // http://sweettutos.com/2015/09/30/how-to-use-the-google-places-autocomplete-api-with-google-maps-sdk-on-ios/

    //https://github.com/John-Lluch/SWRevealViewController
    
    //https://github.com/evnaz/ENSwiftSideMenu
    
    //http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift-2-ios-9/
    
    // https://github.com/teodorpatras/SideMenuController
    
    var locationManager:CLLocationManager!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        mapView = GMSMapView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height ))
        
        var manager = CLLocationManager()
        let userLocation:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(userLocation.latitude, longitude: userLocation.longitude, zoom: 14.0)
        
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true

        
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
      
        

        setupBrandLogo()
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
       
    }
    
    private func setupBrandLogo(){
        
//        brandLogo.centerXAnchor.constraintEqualToAnchor(headerView.centerXAnchor).active = true
//        brandLogo.centerYAnchor.constraintEqualToAnchor(headerView.centerYAnchor).active = true
//        brandLogo.autoresizingMask = .FlexibleBottomMargin
//        brandLogo.translatesAutoresizingMaskIntoConstraints = false
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
        locationTrackingLabel.layer.zPosition = 3
        
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
        let pickupImg = UIImage.fontAwesomeIconWithName(.MapMarker, textColor: UIColor.whiteColor(), size: CGSizeMake(20, 20))
        pickupBtn.userInteractionEnabled = false
        
        pickupBtn.layer.cornerRadius = 12
        pickupBtn.setTitle("Pick me up here", forState: .Normal)
        pickupBtn.setImage(pickupImg, forState: .Normal)
        pickupBtn.backgroundColor = .blackColor()
        pickupBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        pickupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        pickupBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        
        mapView.addSubview(pickupBtn)
        
        pickupBtn.centerXAnchor.constraintEqualToAnchor(mapPin.centerXAnchor).active = true
        pickupBtn.centerYAnchor.constraintEqualToAnchor(mapPin.centerYAnchor, constant: -15).active = true
        pickupBtn.translatesAutoresizingMaskIntoConstraints = false

        pickupBtn.addTarget(self, action: "createPickupRequest", forControlEvents: .TouchUpInside)

    }
    
    func createPickupRequest() {
//        print("address: \(locationTrackingLabel.text) , coord: \(mapView.camera.target)")
        let currentTrip = Trip()
        currentTrip.address(locationTrackingLabel.text!).destinationCoordinates(mapView.camera.target)
        navigationController?.pushViewController(ConfirmPickupFormController(trip: currentTrip), animated: true)
    }
    
    
  
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       
        
    }
  
    // MARK: GMSMapViewDelegate
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        print(mapView.camera.target)
        mapView.clear()
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        reverseGeocodeCoordinate(cameraPosition.target)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines
                
                if let userAddress = address.lines {
                    self.locationTrackingLabel.text = userAddress[0]
                    self.pickupBtn.userInteractionEnabled = true

                }
//                print(lines!.joinWithSeparator("\n"))
                print(lines!)

                // 4
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
   
}

extension PickupRiderController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
//        print("Place name: ", place.name)
//        print("Place address: ", place.formattedAddress)
//        print("Place coordinates: ", place.coordinate)
        self.locationTrackingLabel.text = place.name
        mapView.camera = GMSCameraPosition.cameraWithLatitude(place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}

