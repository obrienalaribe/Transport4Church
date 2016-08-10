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
import ENSwiftSideMenu

class PickupRiderController: UIViewController, GMSMapViewDelegate, ENSideMenuDelegate{

    var mapView : GMSMapView!

   //API Key : AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck
    
    // Server Key : AIzaSyBGSay353rsnXZ14dvFomQLiLaVv9CHiCU

    // http://sweettutos.com/2015/09/30/how-to-use-the-google-places-autocomplete-api-with-google-maps-sdk-on-ios/

    //https://github.com/John-Lluch/SWRevealViewController
    
    //https://github.com/evnaz/ENSwiftSideMenu
    
    //http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift-2-ios-9/
    
    // https://github.com/teodorpatras/SideMenuController
    
    var locationManager:CLLocationManager!
    
    var headerView : UIView!
    
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

    let HEADER_V_OFFSET : CGFloat = 80
    
    
    func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        var button = UIBarButtonItem(
            title: "Menu",
            style: .Plain,
            target: self,
            action: #selector(toggleSideMenu(_:))
        )
        self.navigationItem.leftBarButtonItem = button

        
        mapView = GMSMapView(frame: CGRectMake(0, HEADER_V_OFFSET, view.bounds.width, view.bounds.height - HEADER_V_OFFSET))
        
        var manager = CLLocationManager()
        let userLocation:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(userLocation.latitude, longitude: userLocation.longitude, zoom: 14.0)
        
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true

        
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        headerView = UIView(frame: CGRectMake(0, 0, view.bounds.width, HEADER_V_OFFSET))
        headerView.backgroundColor = .whiteColor()
        view.addSubview(headerView)
        
        let changeLocationBtn = UIButton()
      
        let editBtn = UIImage.fontAwesomeIconWithName(.Amazon, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30))
        changeLocationBtn.frame = CGRectMake(0, 0, 100, 100)
        changeLocationBtn.setImage(editBtn, forState: .Normal)
        changeLocationBtn.addTarget(self, action: #selector(PickupRiderController.autocompleteClicked(_:)), forControlEvents: .TouchUpInside)
        
        headerView.addSubview(changeLocationBtn)

        setupBrandLogo()
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
       
    }
    
    private func setupBrandLogo(){
      
        
        headerView.addSubview(brandLogo)
        
        brandLogo.centerXAnchor.constraintEqualToAnchor(headerView.centerXAnchor).active = true
        brandLogo.centerYAnchor.constraintEqualToAnchor(headerView.centerYAnchor).active = true
        brandLogo.autoresizingMask = .FlexibleBottomMargin
        brandLogo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLocationTrackingLabel() {
        let margins = headerView.layoutMarginsGuide

        headerView.addSubview(locationTrackingLabel)
        
        locationTrackingLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        locationTrackingLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        locationTrackingLabel.topAnchor.constraintEqualToAnchor(headerView.bottomAnchor,
                                                                constant: 8.0).active = true
        locationTrackingLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTrackingLabel.backgroundColor = .whiteColor()
        locationTrackingLabel.heightAnchor.constraintEqualToAnchor(headerView.heightAnchor,
                                                                   multiplier: 0.5).active = true
        
        locationTrackingLabel.layer.zPosition = 3
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapFunction:"))
        locationTrackingLabel.addGestureRecognizer(tap)
        
    }
    
    private func setupMapPin(){
        mapView.addSubview(mapPin)
        
        mapPin.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mapPin.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 10).active = true
        mapPin.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func setupPickupButton(){
        let pickupBtn = UIButton()
        let pickupImg = UIImage.fontAwesomeIconWithName(.MapMarker, textColor: UIColor.whiteColor(), size: CGSizeMake(20, 20))
        
        pickupBtn.layer.cornerRadius = 12
        pickupBtn.setTitle("Pick me up here", forState: .Normal)
        pickupBtn.setImage(pickupImg, forState: .Normal)
        pickupBtn.backgroundColor = .blackColor()
        pickupBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        pickupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        pickupBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        
        mapView.addSubview(pickupBtn)
        
        pickupBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        pickupBtn.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        pickupBtn.translatesAutoresizingMaskIntoConstraints = false

        pickupBtn.addTarget(self, action: "createPickupRequest", forControlEvents: .TouchUpInside)

    }
    
    func createPickupRequest() {
       navigationController?.pushViewController(ConfirmPickupFormController(), animated: true)
    }
    
    
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       
        
    }
  
    // MARK: GMSMapViewDelegate
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        print("i just moved so hide top view")
        mapView.clear()
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        reverseGeocodeCoordinate(cameraPosition.target)
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
                }
                print(lines!.joinWithSeparator("\n"))
                
                // 4
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

   
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked(sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
   
}

extension PickupRiderController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.locationTrackingLabel.text = place.name
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

