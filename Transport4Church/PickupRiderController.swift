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
    var geocoder: GMSGeocoder!
    
    var marker: GMSMarker!


   //API Key : AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck
    
    // Server Key : AIzaSyBGSay353rsnXZ14dvFomQLiLaVv9CHiCU

    // http://sweettutos.com/2015/09/30/how-to-use-the-google-places-autocomplete-api-with-google-maps-sdk-on-ios/

    //https://github.com/John-Lluch/SWRevealViewController
    
    //https://github.com/evnaz/ENSwiftSideMenu
    
    var locationManager:CLLocationManager!
    
    var locationLabel : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
   
    let headerHorizontalOffset : CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView(frame: CGRectMake(0, headerHorizontalOffset, view.bounds.width, view.bounds.height - headerHorizontalOffset))
        
        geocoder = GMSGeocoder()
        marker = GMSMarker()
        marker.map = mapView
       
        var manager = CLLocationManager()
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate


        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(locValue.latitude, longitude: locValue.longitude, zoom: 16.0)
        
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true

        
        view.addSubview(mapView)

        
        let headerView = UIView(frame: CGRectMake(0, 0, view.bounds.width, headerHorizontalOffset))
        headerView.backgroundColor = .whiteColor()
        view.addSubview(headerView)
        
        let changeLocationBtn = UIButton()
      
        changeLocationBtn.setTitle("sdf", forState: .Normal)
        let editBtn = UIImage.fontAwesomeIconWithName(.Amazon, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        changeLocationBtn.frame = CGRectMake(0, 0, 100, 100)
        changeLocationBtn.setImage(editBtn, forState: .Normal)
        changeLocationBtn.addTarget(self, action: #selector(PickupRiderController.autocompleteClicked(_:)), forControlEvents: .TouchUpInside)
        
        headerView.addSubview(changeLocationBtn)
        headerView.addSubview(locationLabel)
        
        let margins = headerView.layoutMarginsGuide
        
        locationLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        locationLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        locationLabel.topAnchor.constraintEqualToAnchor(headerView.bottomAnchor,
                                                             constant: 8.0).active = true
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.backgroundColor = .whiteColor()
        locationLabel.text = "Hello World"

//        headerView.addConstraintsWithFormat("H:[v0]|", views: locationLabel)
//        headerView.addConstraintsWithFormat("V:[v0]|", views: locationLabel)

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let handler = { (response: GMSReverseGeocodeResponse?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                self.locationLabel.text = result.lines?[0]
//                marker.snippet = result.lines?[1]
                
                print(result.lines?[0])
            }else{
                print("mumum")
            }
            
        }
        
    }
  
    // MARK: GMSMapViewDelegate
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        print("i just moved so hide top view")
        mapView.clear()
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        let handler = { (response: GMSReverseGeocodeResponse?, error: NSError?) -> Void in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = mapView
                marker.draggable = true
                
                
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
        self.locationLabel.text = place.name
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

