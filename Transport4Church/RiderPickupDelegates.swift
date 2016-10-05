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
        if gesture {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
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
            }
            
            
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath! == "myLocation" {
           
            
        }
    }
    
}

// MARK: RiderTripDetailControllerDelegate

extension RiderPickupController: RiderTripDetailControllerDelegate {
    
    func riderWillCancelTrip() {
        let alertController = UIAlertController (title: "Contact Driver", message: "Please choose what action you would like to take", preferredStyle: .Alert)
        
        let callDriverAction = UIAlertAction(title: "Speak to Driver", style: .Default) { (_) -> Void in
            let driverPhoneNum = "07411411590"
            if let url = NSURL(string: "tel://\(driverPhoneNum)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        let confirmAction = UIAlertAction(title: "Cancel Pickup", style: .Default) { (_) -> Void in
            //TODO: Send socket request to notify the driver
            
            self.tripDetailController.removeFromParentViewController()
            self.tripDetailController.view.removeFromSuperview()
            self.toggleViewForCurrentTripMode()

             self.currentTrip.status = .CANCELLED
             self.currentTrip.saveInBackgroundWithBlock({ (success, error) in
                self.startNetworkActivity()
             })
        }
        
        let cancelAction = UIAlertAction(title: "Exit", style: .Default) { (_) -> Void in
           
        }
        
        alertController.addAction(callDriverAction)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

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
        if self.riderMapViewDidInitialiseWithLocation == false {
            //first app launch when they is a delay with map update
            setRiderLocationOnMap()
        }

    }
    
    
}
