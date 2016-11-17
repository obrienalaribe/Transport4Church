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
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        let helper = LocationHelper()
        helper.reverseGeocodeCoordinate(cameraPosition.target)
        
        locationDispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("location from camera : \(helper.result)")
            self.locationTrackingLabel.textColor = UIColor.black
            
            if self.currentTrip != nil {
                if self.currentTrip.status == TripStatus.NEW || self.currentTrip.status == TripStatus.CANCELLED {
                    //only update rider location on view during pickup mode
                    self.locationTrackingLabel.text = helper.result[0]
                    
                }
                
                self.currentTrip.rider.location = PFGeoPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
                
                let address = Address(result: helper.result, coordinate: cameraPosition.target)
                
                self.currentTrip.rider.address = address
                self.currentTrip.rider.addressDic = address.getDictionary()
                
                self.pickupBtn.isUserInteractionEnabled = true

                self.currentTrip.rider.saveInBackground()
                
//                if self.pickupBtn.isUserInteractionEnabled {
//                    
//                    self.animatePickupBtn()
//                }
            }
        })
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! == "myLocation" {
           
            
        }
    }
    
    func animatePickupBtn(){
        DispatchQueue.main.async(execute: { () -> Void in
            //run ui updates on main thread
            self.pickupBtn.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            
            UIView.animate(withDuration: 2.0, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 4.00, options: UIViewAnimationOptions.allowUserInteraction,animations: {self.pickupBtn.transform = CGAffineTransform.identity
                }, completion: nil)
        })
    }
    
}

// MARK: RiderTripDetailControllerDelegate

extension RiderPickupController: TripStateControllerDelegate {
    
    func riderWillCancelTrip() {
        let alertController = UIAlertController (title: "Contact Driver", message: "Please choose what action you would like to take", preferredStyle: .alert)
        
    
        let confirmAction = UIAlertAction(title: "Cancel Pickup", style: .default) { (_) -> Void in
            //TODO: Send socket request to notify the driver
            self.toggleViewForCurrentTripMode(state: .REQUESTED)
            
            self.currentTrip.status = .CANCELLED
            self.currentTrip.saveInBackground(block: { (success, error) in
                self.startNetworkActivityForTripReset()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Exit", style: .default) { (_) -> Void in
            
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func driverDidCancelTrip(){
        let alertController = UIAlertController (title: "Driver cancelled trip", message: "Please choose what action you would like to take", preferredStyle: .alert)
        
        let callDriverAction = UIAlertAction(title: "Speak to Driver", style: .default) { (_) -> Void in
            if let driver = self.driver {
                if let driverPhoneNum = driver["contact"] {
                    if let url = URL(string: "tel://\(driverPhoneNum)") {
                        UIApplication.shared.openURL(url)
                    }
                }
            }else{
                print("driver was \(self.driver)")
            }
            self.startNetworkActivityForTripReset()
            
        }
        
        let confirmAction = UIAlertAction(title: "Accept", style: .default) { (_) -> Void in
            
            self.startNetworkActivityForTripReset()
        }
        
        alertController.addAction(callDriverAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)

    }
}

// MARK: GMSAutocompleteViewControllerDelegate

extension RiderPickupController: GMSAutocompleteViewControllerDelegate {
 
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: ", place.name)
        //        print("Place address: ", place.formattedAddress)
        //        print("Place coordinates: ", place.coordinate)
        self.locationTrackingLabel.text = place.name
        mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

// MARK: CLLocationManagerDelegate

extension RiderPickupController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
            print("why did you decline ?")
            
            manager.requestWhenInUseAuthorization()
            
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            print("thanks for accepting ")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.riderMapViewDidInitialiseWithLocation == false {
            //first app launch when they is a delay with map update
            setRiderLocationOnMap()
            
            //set delay and then ask for notifications
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                NotificationHelper.setupNotification()
            })
        }

    }
    
    
}
