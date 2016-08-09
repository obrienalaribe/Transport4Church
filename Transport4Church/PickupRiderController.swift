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

class PickupRiderController: UIViewController, GMSMapViewDelegate{

    var mapView : GMSMapView!
    var geocoder: GMSGeocoder!
    
 

   //API Key : AIzaSyCRbgOlz9moQ-Hlp65-piLroeMtfpNouck
    
    // Server Key : AIzaSyBGSay353rsnXZ14dvFomQLiLaVv9CHiCU

    // http://sweettutos.com/2015/09/30/how-to-use-the-google-places-autocomplete-api-with-google-maps-sdk-on-ios/

    var locationManager:CLLocationManager!

    let headerHorizontalOffset : CGFloat = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView(frame: CGRectMake(0, headerHorizontalOffset, view.bounds.width, view.bounds.height - headerHorizontalOffset))
        
        geocoder = GMSGeocoder()
        
        //Default position at Chungli (Zhongli) Railway Station, Taoyuan, Taiwan.
        mapView.camera = GMSCameraPosition.cameraWithLatitude(53.8008, longitude: -1.5491, zoom: 16.0)
        
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        
        
        view.addSubview(mapView)

        
        let headerView = UIView(frame: CGRectMake(0, 0, view.bounds.width, headerHorizontalOffset))
        headerView.backgroundColor = .whiteColor()
        view.addSubview(headerView)
        
        let pickupButton = UIButton()
        
        pickupButton.setTitle("Pick up", forState: .Normal)
        pickupButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        pickupButton.frame = CGRectMake(0, 0, 100, 100)
        pickupButton.addTarget(self, action: #selector(PickupRiderController.autocompleteClicked(_:)), forControlEvents: .TouchUpInside)
        
        headerView.addSubview(pickupButton)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        mapView.animateToLocation(CLLocationCoordinate2D(latitude: 53.8008, longitude: -1.5491))
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
                
                print("\(marker.title)")

            }
        }
        geocoder.reverseGeocodeCoordinate(cameraPosition.target, completionHandler: handler)
        
        print("i am idle man")
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

