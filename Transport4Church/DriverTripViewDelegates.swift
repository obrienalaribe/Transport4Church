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
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let helper = LocationHelper()
        helper.reverseGeocodeCoordinate(cameraPosition.target)
        
        locationDispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("hence \(helper.result)")
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) 
        })
                
    }
    
    
}


// MARK: CLLocationManagerDelegate

extension DriverTripViewController : CLLocationManagerDelegate {
    
}
