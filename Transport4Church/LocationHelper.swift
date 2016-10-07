//
//  LocationHelper.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 16/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation

var locationDispatchGroup = DispatchGroup()

class LocationHelper {
   
    var result : [String] = [String]()
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) -> Void {
        let geocoder = GMSGeocoder()
        
        locationDispatchGroup.enter()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                self.result = address.lines!
                locationDispatchGroup.leave()

            }
        }
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let result : Double = 0.1
//        (self * divisor).rounded / divisor
    
        return result
    }
}
