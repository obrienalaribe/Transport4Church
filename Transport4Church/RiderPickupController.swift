//
//  PickupRiderController.swift
//  Transport4Church
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Parse
import BRYXBanner

let appLaunchCount = "count"

class RiderPickupController: UIViewController, NVActivityIndicatorViewable {
    
    var mapView : GMSMapView!
    var locationManager = CLLocationManager()
    var driverPreviousDistanceInMiles = 0.0

    var mockJourneyCheckpoint = 3

    //http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift-2-ios-9/
    
    var locationTrackingLabel : UILabel = {
        let label = UILabel(frame: CGRectMake(0, 0, 200, 40))
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    let mapPin : UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "map_pin")
        return view
    }()
    
    let brandLogo  : UIImageView = {
        let view = UIImageView()
        view.contentMode = .ScaleAspectFit
        view.image = UIImage(named: "brand_logo")
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    var pickupBtn : UIButton!
    var callDriverBtn : UIButton!
    var cancelTripBtn : UIBarButtonItem!
    
    var riderMapViewDidInitialiseWithLocation : Bool? = nil
    
    var currentTrip : Trip!
    
    var driverLocation : GMSMarker!
    
    var tripDetailController: RiderTripDetailController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transport4Church"
        
        mapView = GMSMapView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height ))
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(12, maxZoom: 16)
        
                
        view.addSubview(mapView)
        
        print(self.mapView.myLocation)
        
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
        setupViewObservers()
        
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(RiderPickupController.showMenu))
        menuBtn.tintColor = .blackColor()
        navigationItem.leftBarButtonItem = menuBtn
        
        cancelTripBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .Plain, target: self, action: #selector(RiderPickupController.cancelTripAlert))
        
        cancelTripBtn.tintColor = .clearColor()
        navigationItem.rightBarButtonItem = cancelTripBtn
        cancelTripBtn.enabled = false
        
    }
    
    
    func showMenu() {
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.presentViewController(menuNavCtrl, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if self.currentTrip == nil {
            //initial state before trip is initialized
            setRiderLocationOnMap()
        }else{
            
            if self.currentTrip?.status == TripStatus.REQUESTED {
                modallyDisplayTripDetails()
            }
            
            listenForSocketConnection()
        }
        
        //TODO: use Socket to detect when trip is complete and then ToggleTripMode

        
    }


    func setRiderLocationOnMap(){
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        print("seting up rider and trip")
        if let location = locationManager.location {
            self.riderMapViewDidInitialiseWithLocation = true

            let rider = Rider()
            rider.location = PFGeoPoint(location: location)
            
            rider.user = PFUser.currentUser()!
            
            self.currentTrip = Trip()
            self.currentTrip.rider = rider
            self.currentTrip.status = TripStatus.NEW

            
            let riderLatitude = self.currentTrip.rider.location.latitude
            let riderLongitude = self.currentTrip.rider.location.longitude
            
//            mapView.camera = GMSCameraPosition.cameraWithLatitude(riderLatitude, longitude: riderLongitude, zoom: 14.0)
           
            mapView.animateToLocation(CLLocationCoordinate2D(latitude: riderLatitude, longitude: riderLongitude))
            mapView.animateToZoom(14)
            
        }else{
            self.riderMapViewDidInitialiseWithLocation = false
            
            print("location service not enabled")

        }
        
       
    }
    
    func setupActiveTripModeView(position: CLLocationCoordinate2D){
//        setupPushNotification()
        
        print("trip mode activated ")
        toggleViewForCurrentTripMode()
    
        driverLocation = GMSMarker(position: position)
        driverLocation.title = "EFA Church Bus"
        driverLocation.flat = true
        
        driverLocation.icon = UIImage(named: "bus")!.imageWithRenderingMode(.AlwaysTemplate)
        driverLocation.map = mapView
      
        let bounds = GMSCoordinateBounds(coordinate: self.currentTrip.rider.address.coordinate, coordinate: driverLocation.position)
        let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))!
        self.mapView.camera = camera
        
        setupCallDriverButton()
    
    }
    
    func updateDriverMarker(position: CLLocationCoordinate2D){
      
        print("updating driver location on map")
        driverLocation.position = position
        
        let riderLoc = CLLocation(latitude: self.currentTrip.rider.address.coordinate.latitude, longitude: self.currentTrip.rider.address.coordinate.longitude)
        let driverLoc = CLLocation(latitude: driverLocation.position.latitude, longitude: driverLocation.position.longitude)
        
        let distanceInMeters = riderLoc.distanceFromLocation(driverLoc)
        let distanceInMiles = distanceInMeters/1609.344
        let distanceString = String(format: "%.1f miles away from you", distanceInMiles)
        
        
        driverLocation.snippet = distanceString

        
        if driverPreviousDistanceInMiles.roundToPlaces(0) != distanceInMiles.roundToPlaces(0) {
            //driver made signficant change in distance
            updateArrivalTime()
            print("previous: \(driverPreviousDistanceInMiles) vs new \(distanceInMiles)")
            driverPreviousDistanceInMiles = distanceInMiles
            print("driver made signficant change in distance")
        }
        
    }
    
    //TODO: could move this to location helper
    func updateArrivalTime(){
        //leeds aiport, church, manor mills
        
        let locationMock = [[53.86794339999999, -1.6615305999999919] , [53.801277 , -1.548567], [53.789478,-1.549928]]
//        
//        let requestUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=ls29aa&destinations=ls119bn&mode=driving"
//        Alamofire.request(.GET, requestUrl, parameters: ["foo": "bar"])
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    if let result = response.result.value {
//                        let time: String = ("\(JSON(result)["rows"][0]["elements"][0]["duration"]["text"])")
//                        self.locationTrackingLabel.text = "Pickup time: \(time)"
//                    }
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//        
        self.locationTrackingLabel.text = "Driver will arrive in \(driverPreviousDistanceInMiles.roundToPlaces(0)) mins"
        
    }
    
    private func setupLocationTrackingLabel() {
        let margins = view.layoutMarginsGuide
        view.addSubview(locationTrackingLabel)
        
        locationTrackingLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        locationTrackingLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        locationTrackingLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor,
                                                                constant: 8.0).active = true
        locationTrackingLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTrackingLabel.backgroundColor = .whiteColor()
        locationTrackingLabel.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                                   multiplier: 0.1).active = true
        locationTrackingLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(updateLocationAction))
        locationTrackingLabel.addGestureRecognizer(tap)
    }
    
    func updateLocationAction(sender:UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
        
    }
    
    private func setupCallDriverButton(){
        callDriverBtn = UIButton()
        callDriverBtn.setTitle("Call Driver", forState: .Normal)
        callDriverBtn.backgroundColor = .whiteColor()
        callDriverBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        callDriverBtn.alpha = 0.4
        
        view.addSubview(callDriverBtn)

        callDriverBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        callDriverBtn.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                              multiplier: 0.1).active = true
        
        callDriverBtn.widthAnchor.constraintEqualToAnchor(view.widthAnchor,
                                                             multiplier: 0.5).active = true
        
        callDriverBtn.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: -10).active = true
        
        callDriverBtn.translatesAutoresizingMaskIntoConstraints = false
        
        callDriverBtn.addTarget(self, action: "callDriver", forControlEvents: .TouchUpInside)
        
    }
    
    func callDriver(){
        let alertController = UIAlertController (title: "Call Driver", message: "Would you like to call the driver?", preferredStyle: .Alert)
        
        let settingsAction = UIAlertAction(title: "Yes, Call Driver", style: .Default) { (_) -> Void in
            let driverContact: String = "07778889077"
            if let url = NSURL(string: "tel://\(driverContact)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "No, Cancel", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    func toggleViewForCurrentTripMode(){
        if self.currentTrip.status == .REQUESTED {
            
            self.tripDetailController.removeFromParentViewController()
            self.tripDetailController.view.removeFromSuperview()
        }
        
        if self.currentTrip.status == .STARTED {
            self.locationTrackingLabel.userInteractionEnabled = false
            self.pickupBtn.hidden = true
            self.mapPin.hidden = true
            self.cancelTripBtn.enabled = true
            self.cancelTripBtn.tintColor = .blackColor()
        }
       
        if self.currentTrip.status == TripStatus.CANCELLED {
            self.locationTrackingLabel.userInteractionEnabled = true
            self.pickupBtn.hidden = false
            self.mapPin.hidden = false
            self.cancelTripBtn.enabled = false
            self.cancelTripBtn.tintColor = .clearColor()
            
            if driverLocation != nil {
                //remove driver marker from map
                driverLocation.map = nil
                self.callDriverBtn.hidden = true
            }
            
           setRiderLocationOnMap()
        }
        
    }
    
    private func setupMapPin(){
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mapPin.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -30).active = true
        mapPin.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPickupButton(){
        pickupBtn = UIButton()
        pickupBtn.userInteractionEnabled = false //disable till user location is determined
        pickupBtn.layer.cornerRadius = 12
        pickupBtn.setTitleColor(.darkGrayColor(), forState: .Normal)
        pickupBtn.setTitle("Pick me up here", forState: .Normal)
        pickupBtn.backgroundColor = UIColor(white: 1, alpha: 1)
        pickupBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        mapView.addSubview(pickupBtn)
        
        pickupBtn.centerXAnchor.constraintEqualToAnchor(mapPin.centerXAnchor).active = true
        pickupBtn.centerYAnchor.constraintEqualToAnchor(mapPin.centerYAnchor, constant: -18).active = true
        pickupBtn.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.5).active = true
        pickupBtn.translatesAutoresizingMaskIntoConstraints = false
        
        pickupBtn.addTarget(self, action: #selector(RiderPickupController.createPickupRequest), forControlEvents: .TouchUpInside)
    }
    
    func createPickupRequest() {
        //TODO: current trip should be initialized at first call so that trip status is NEW not nil
        navigationController?.pushViewController(ConfirmPickupFormController(trip: self.currentTrip), animated: true)
    }
    
    func setupViewObservers() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleLocationAuthorizationState), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func handleLocationAuthorizationState(){
        if !riderMapViewDidInitialiseWithLocation! {
            let alertController = UIAlertController (title: "Location Required", message: "You have disabled location usage. Kindly visit your settings and turn it on ", preferredStyle: .Alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            setRiderLocationOnMap()
            print("view loaded from background ")

        }
        
    }
    

    
    func startNetworkActivity(){
        let size = CGSize(width: 30, height:30)
        
        startActivityAnimating(size, message: "Please wait", type: NVActivityIndicatorType(rawValue: 17)!)
        performSelector(#selector(delayedStopActivity),
                        withObject: nil,
                        afterDelay: 2.5)
    }
    
    func delayedStopActivity() {
        stopActivityAnimating()
        self.locationTrackingLabel.alpha = 1
        self.mapView.alpha = 1
    }
    
    func modallyDisplayTripDetails(){

        tripDetailController = RiderTripDetailController(trip: currentTrip)
        tripDetailController.delegate = self
        tripDetailController.willMoveToParentViewController(self)
        self.view.addSubview(tripDetailController.view)
        self.addChildViewController(tripDetailController)
        tripDetailController.didMoveToParentViewController(self)
        self.mapView.alpha = 0.5
        self.locationTrackingLabel.alpha = 0.1

        tripDetailController.view.alpha = 1
        
    }
    
    func cancelTripAlert(){
        let alertController = UIAlertController (title: "Cancel Pickup", message: "Are you sure you would like to cancel your pickup? The driver would not be able to pick you up", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Yes, Cancel Pickup", style: .Default) { (_) -> Void in
            //TODO: Send socket request to notify the driver
            
            self.currentTrip.status = .CANCELLED
            self.currentTrip.saveInBackgroundWithBlock({ (success, error) in
                self.startNetworkActivity()

            })
        }
        
        let cancelAction = UIAlertAction(title: "Exit", style: .Default) { (_) -> Void in
            
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func listenForSocketConnection(){
        SocketIOManager.sharedInstance.getDriverLocation { (locationInfo) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //run ui updates on main thread
                
                self.toggleViewForCurrentTripMode()
                
                if self.currentTrip.status == .REQUESTED {
                    
                    let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.9 * Double(NSEC_PER_SEC)))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        let banner = Banner(title: "Pickup Request Accepted!!", subtitle: "The church bus is on its way now", image: UIImage(named: "bus"), backgroundColor: BrandColours.PRIMARY.color)
                        banner.dismissesOnTap = false
                        banner.show(duration: 3.0)
                        
                    })
                    
                    self.mapView.alpha = 1
                    self.locationTrackingLabel.alpha = 1
                    
                    self.currentTrip.status = .STARTED
                    self.currentTrip.saveEventually()
                    self.setupActiveTripModeView(locationInfo)
                    
                    NotificationHelper.scheduleLocal("The church bus is on its way", status: "accepted", alertDate: NSDate())
                }
                
                if self.currentTrip.status == .STARTED {
                    self.updateDriverMarker(locationInfo)
                }
                //
                
            })
            //TODO: Need to stop socket on driver
            print("Socket receiving driver location ... ")
            
        }

    }
}


