//
//  RiderPickupDelegates.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import GooglePlaces
import Parse

// MARK: GMSMapViewDelegate

extension RiderPickupController : GMSMapViewDelegate{
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //        mapView.clear()
        
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        
        let helper = LocationHelper()
        helper.reverseGeocodeCoordinate(cameraPosition.target)
        
        dispatch_group_notify(locationDispatchGroup, dispatch_get_main_queue(), {
            print("location from camera : \(helper.result)")
            self.locationTrackingLabel.textColor = .blackColor()
            
            self.pickupBtn.userInteractionEnabled = true
            
            if self.currentTrip != nil {
                if self.currentTrip.status == TripStatus.NEW || self.currentTrip.status == TripStatus.CANCELLED {
                    //only update rider location on view during pickup mode
                    self.locationTrackingLabel.text = helper.result[0]
                    
                }
                
                self.currentTrip.rider.location = PFGeoPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
                
                let address = Address(result: helper.result, coordinate: cameraPosition.target)
                
                self.currentTrip.rider.address = address
                self.currentTrip.rider.addressDic = address.getDictionary()
                
                self.currentTrip.rider.saveInBackground()
                print(self.currentTrip.status)
                
            }
            
            
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath! == "myLocation" {
            
            let address =  PFGeoPoint(latitude: (self.mapView.myLocation?.coordinate.latitude)!, longitude: (self.mapView.myLocation?.coordinate.longitude)!)
            
            if self.currentTrip != nil {
                let oldLocation = CLLocation(latitude: self.currentTrip.rider.location.latitude, longitude: self.currentTrip.rider.location.longitude)
                
                var newLocation : CLLocation? = nil
                
                
                newLocation = CLLocation(latitude: (self.mapView.myLocation?.coordinate.latitude)!, longitude: (self.mapView.myLocation?.coordinate.longitude)!)
                
                if let distance = newLocation?.distanceFromLocation(oldLocation) {
                    let distanceInMeters = (newLocation?.distanceFromLocation(oldLocation))! / 1609.344
                    print("distance in miles \(distanceInMeters)")
                    
                    if distanceInMeters >= 0.009 {
                        //rider physical just moved from their previous location (so update location label)
                        self.updateLocationLabel(CLLocationCoordinate2D(latitude: (newLocation?.coordinate.latitude)!, longitude: (newLocation?.coordinate.longitude)!))
                        
                    }else{
                        
                    }
                    
                }
                
            }
            
            
        }
    }
    
    func updateLocationLabel(location: CLLocationCoordinate2D) -> Void {
        let helper = LocationHelper()
        helper.reverseGeocodeCoordinate(location)
        
        dispatch_group_notify(locationDispatchGroup, dispatch_get_main_queue(), {
            print("location from function : \(helper.result)")
            //            self.rider.location.updateProperties(helper.result)
            self.pickupBtn.userInteractionEnabled = true
            
            if self.currentTrip != nil {
                if self.currentTrip.status == TripStatus.NEW || self.currentTrip.status == TripStatus.CANCELLED {
                    //only update rider location on view during pickup mode
                    self.locationTrackingLabel.text = helper.result[0]
                    print(helper.result[0])
                    self.locationTrackingLabel.textColor = .greenColor()
                }
                
            }
            
            
        })
        
        
        
        
    }
    
}

extension RiderPickupController: RiderTripDetailControllerDelegate {
    
    func riderDidCancelTrip() {
        self.view.alpha = 1
    }
}

// MARK: GMSAutocompleteViewControllerDelegate

extension RiderPickupController: GMSAutocompleteViewControllerDelegate {
    
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

// MARK: CLLocationManagerDelegate

extension RiderPickupController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.Denied) {
            // The user denied authorization
            print("why did you decline ?")
            
            manager.requestWhenInUseAuthorization()
            
            
        } else if (status == CLAuthorizationStatus.AuthorizedAlways) {
            // The user accepted authorization
            print("thanks for accepting ")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location managaer updated \(locations)")
    }
}
