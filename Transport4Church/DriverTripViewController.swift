//
//  DriverTripViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 14/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import BRYXBanner

class DriverTripViewController: UIViewController {
    
    var mapView : GMSMapView!

    var currentTrip : Trip?
    var driverLocation : CLLocation!

    init(trip: Trip){
        self.currentTrip = trip
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
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        view.addSubview(mapView)
        
        title = currentTrip?.rider.user["name"] as! String
   
        let completeTripBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .Plain, target: self, action: #selector(DriverTripViewController.completeTrip))
        
        completeTripBtn.tintColor = .blackColor()
        navigationItem.rightBarButtonItem = completeTripBtn
        
        let callRiderBtn =  UIBarButtonItem(image: UIImage(named: "plain_phone"), style: .Plain, target: self, action: #selector(DriverTripViewController.callRider))
        
        callRiderBtn.tintColor = .blackColor()
        navigationItem.leftBarButtonItem = callRiderBtn

    }
    
    func completeTrip(){
        let alertController = UIAlertController (title: "Pickup Complete", message: "Has this rider been picked up ?", preferredStyle: .Alert )
        
        let yesAction = UIAlertAction(title: "Yes, Complete", style: .Default) { (_) -> Void in
            self.currentTrip?.status = TripStatus.COMPLETED
            self.currentTrip?.saveEventually()
            self.navigationController?.setViewControllers([DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func callRider(){
        let riderPhone = currentTrip?.rider.user["contact"] as! String
        if let url = NSURL(string: "tel://\(riderPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        setDriverLocationOnMap()
        
        let riderPosition = CLLocationCoordinate2D(latitude: (currentTrip?.rider.location.latitude)!, longitude: (currentTrip?.rider.location.longitude)!)
        
        let riderLocation = GMSMarker(position: riderPosition)
        
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

          _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.sendDriverLocation), userInfo: nil, repeats: true)
        
    }
    

    
    func setDriverLocationOnMap(){
        let manager = CLLocationManager()
        manager.delegate = self
        
        if let location = manager.location {
            let driverLatitude = location.coordinate.latitude
            let driverLongitude = location.coordinate.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.cameraWithLatitude(driverLatitude, longitude: driverLongitude, zoom: 14.0)
            
        }else{
            //mock driver location on simulator
            let driverLatitude = EFA_Coord.latitude
            let driverLongitude = EFA_Coord.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.cameraWithLatitude(driverLatitude, longitude: driverLongitude, zoom: 14.0)

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //start timer to emit driver location
        
    }
    
    
    func sendDriverLocation(timer: NSTimer){
        let padLat : Double = (driverLocation.coordinate.latitude) - 0.0001
        let padLong : Double = (driverLocation.coordinate.longitude)  + 0.0001
        
        driverLocation = CLLocation(latitude: padLat, longitude: padLong)
        
        let riderLoc = CLLocation(latitude: self.currentTrip!.rider.location.latitude, longitude: self.currentTrip!.rider.location.longitude)
        
        let distanceInMeters = riderLoc.distanceFromLocation(driverLocation)
        let distanceInMiles = distanceInMeters/1609.344
        let distanceString = String(format: "%.1f miles away from you", distanceInMiles)
        
        //send driver location through socket
        SocketIOManager.sharedInstance.sendDriverLocation(driverLocation) {
            print("location sent sucessefully ")
        }
        
    }
    
    
   
}
