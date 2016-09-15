//
//  DriverTripViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 14/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

class DriverTripViewController: UIViewController {
    
    var mapView : GMSMapView!

    var currentTrip : Trip?
    var driverLocation : CLLocation?

    init(trip: Trip){
        self.currentTrip = trip
        print(currentTrip!.rider)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height ))
        mapView.mapType = kGMSTypeTerrain
        mapView.delegate = self
        mapView.setMinZoom(12, maxZoom: 16)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        
        view.addSubview(mapView)
        
        title = currentTrip?.rider.user["name"] as! String
   
        let cancelTrip =  UIBarButtonItem(image: UIImage(named: "close"), style: .Plain, target: self, action: #selector(DriverTripViewController.cancelTrip))
        
        cancelTrip.tintColor = .blackColor()
        navigationItem.rightBarButtonItem = cancelTrip
        
        
    }
    
    func cancelTrip(){
        let alertController = UIAlertController (title: "Cancel Pickup", message: "Are you sure you want to cancel this pickup ?", preferredStyle: .Alert )
        
        let yesAction = UIAlertAction(title: "Yes, Cancel", style: .Default) { (_) -> Void in
              self.navigationController?.setViewControllers([DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        setDriverLocationOnMap()
        
        
        let mockRiderPosition = CLLocationCoordinate2D(latitude: 53.787302434358566, longitude: -1.5659943222999573)
        
        let riderLocation = GMSMarker(position: mockRiderPosition)
        
        if let rider = currentTrip?.rider  {
            riderLocation.snippet = "\(rider.addressDic["street"]!) \(rider.addressDic["postcode"]!)"

            riderLocation.title = rider.user["name"] as! String

        }
        riderLocation.flat = true
        
        riderLocation.icon = UIImage(named: "user")!.imageWithRenderingMode(.AlwaysTemplate)
        riderLocation.map = mapView
        
        let driverCoordinates = CLLocationCoordinate2D(latitude: (driverLocation?.coordinate.latitude)!, longitude: (driverLocation?.coordinate.longitude)!)
        let bounds = GMSCoordinateBounds(coordinate: driverCoordinates, coordinate: riderLocation.position)
        let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))!
        self.mapView.camera = camera
 
        mapView.settings.myLocationButton = false

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
    func setDriverLocationOnMap(){
        let manager = CLLocationManager()
        manager.delegate = self
        
        if let location = manager.location {
            let driverLatitude = location.coordinate.latitude
            let driverLongitude = location.coordinate.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.cameraWithLatitude(driverLatitude, longitude: driverLongitude, zoom: 14.0)
            
        }
    }
   
}
