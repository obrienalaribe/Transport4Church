//
//  RiderPickupDelegates.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import GooglePlaces

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
            print("hence \(helper.result)")
            self.rider.location.updateProperties(helper.result)
            self.pickupBtn.userInteractionEnabled = true
            
            if self.currentTrip?.status == nil {
                //only update before active trip requested mode
                self.locationTrackingLabel.text = helper.result[0]

            }

            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
        })

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
    
    
}
