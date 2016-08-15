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
        print(mapView.camera.target)
//        mapView.clear()
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        reverseGeocodeCoordinate(cameraPosition.target)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //        Driver Pickup Mode
        //        let position = CLLocationCoordinate2D(latitude: 53.787302434358566, longitude: -1.5659943222999573)
        //
        //        driverLocation = GMSMarker(position: position)
        //        driverLocation.icon = UIImage(named: "driver")
        //        driverLocation.map = mapView
        //
        //        let bounds = GMSCoordinateBounds(coordinate: self.userCoordinate, coordinate: driverLocation.position)
        //        let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))!
        //        mapView.camera = camera
        
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
                    self.pickupBtn.userInteractionEnabled = true
                    //                    let attributedText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                    //
                    //                    attributedText.appendAttributedString(NSAttributedString(string: "" ,
                    //                        attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]))
                    //
                    //                    let paragraphStyle = NSMutableParagraphStyle()
                    //                    paragraphStyle.lineSpacing = 4
                    //                    attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range:NSMakeRange(0, attributedText.string.characters.count))
                    //
                    //                    let attachment = NSTextAttachment()
                    //                    attachment.image = UIImage(named: "edit_pen")
                    //                    attachment.bounds = CGRectMake(-95, -20, 12, 12)
                    //                    attributedText.appendAttributedString(NSAttributedString(attachment: attachment))
                    //
                    //                    self.locationTrackingLabel.textAlignment = .Center
                    //                    self.locationTrackingLabel.attributedText = attributedText
                    self.locationTrackingLabel.text = userAddress[0]
                    
                    
                    
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
