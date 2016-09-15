//
//  DriverTripViewDelegates.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 14/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

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

extension DriverTripViewController : GMSMapViewDelegate{
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {

    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition cameraPosition: GMSCameraPosition) {
        let helper = LocationHelper()
        helper.reverseGeocodeCoordinate(cameraPosition.target)
        
        dispatch_group_notify(locationDispatchGroup, dispatch_get_main_queue(), {
            print("hence \(helper.result)")
            
            
            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
        })
                
    }
    
    
}


// MARK: CLLocationManagerDelegate

extension DriverTripViewController : CLLocationManagerDelegate {
    
}
