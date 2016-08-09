//
//  PickupRiderController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Eureka
import MapKit

class PickupRiderController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    lazy var mapView : MKMapView = {
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        return v
        }()
    
  

    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView.delegate = self
        view.addSubview(mapView)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

       
    }
    
   
}
