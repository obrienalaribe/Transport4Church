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

class RiderPickupController: UIViewController {
    
    var mapView : GMSMapView!
    
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
    var cancelTripButton : UIButton!
    var userLocationPermissionEnabled : Bool? = nil
    
    var currentTrip : Trip?
    var rider: Rider!
    
    var driverLocation : GMSMarker!
    var previousDistanceInMiles: Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transport4Church"
        
        mapView = GMSMapView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height ))
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
//        mapView.setMinZoom(12, maxZoom: 16)
        
        view.addSubview(mapView)
        
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
        setupViewObservers()
        
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: "showMenu")
        menuBtn.tintColor = .blackColor()
        let driverView = UIBarButtonItem(title: "DriverView", style: .Plain, target: self, action:"showDriverView")

        navigationItem.leftBarButtonItem = menuBtn
        navigationItem.rightBarButtonItem = driverView
        
        test()
    }
    
    func showMenu() {
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.presentViewController(menuNavCtrl, animated: true, completion: nil)
    }
    
    func showDriverView() {
        navigationController?.pushViewController(DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if self.currentTrip?.status == nil {
            //initial state before trip is initialized
            setRiderLocationOnMap()
        }
        
        if let tripStatus = self.currentTrip?.status {
            if tripStatus == TripStatus.REQUESTED {
                setupActiveTripModeView()
            }
        }
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //start an animations or the loading of external data from an API or checks for location permission
        
        //TODO: Check if user is connected to the internet first
//                handleLocationAuthorizationState()
        
    
//
    }

    func setRiderLocationOnMap(){
        let manager = CLLocationManager()
        manager.delegate = self
        
        if let location = manager.location {
            let fakeUser = User(name: "John Okafor", gender: "Male", email: "john@gmail.com", role: .Rider, username: "sdfds", password: "dfdd")
            
            let fakeDest = CLLocationCoordinate2DMake(53.789607182624763, -1.5980678424239159) //remove this in prod
            
            self.rider = Rider(location: Address(coordinate: location.coordinate), destination: Address(coordinate: fakeDest), userDetails: fakeUser)
            
            self.userLocationPermissionEnabled = true
            let riderLatitude = self.rider.location.coordinate.latitude
            let riderLongitude = self.rider.location.coordinate.longitude
            
            mapView.camera = GMSCameraPosition.cameraWithLatitude(riderLatitude, longitude: riderLongitude, zoom: 14.0)
           
//            mapView.animateToLocation(CLLocationCoordinate2D(latitude: riderLatitude, longitude: riderLongitude))
            
        }else{
            //            manager.requestWhenInUseAuthorization()
            self.userLocationPermissionEnabled = false
        }
        
       
    }
    
    func setupActiveTripModeView(){
        toggleTripMode()
        previousDistanceInMiles = 0.0
        
        let position = CLLocationCoordinate2D(latitude: 53.787302434358566, longitude: -1.5659943222999573)
    
        driverLocation = GMSMarker(position: position)
        driverLocation.title = "EFA Church Bus"
        driverLocation.flat = true
        
        driverLocation.icon = UIImage(named: "driver")!.imageWithRenderingMode(.AlwaysTemplate)
        driverLocation.map = mapView
      
        let bounds = GMSCoordinateBounds(coordinate: self.rider.location.coordinate, coordinate: driverLocation.position)
        let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))!
        self.mapView.camera = camera
        
        setupCancelButton()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.updateDriverMarker), userInfo: nil, repeats: true)
       
    }
    
    func updateDriverMarker(timer: NSTimer){
        let padLat : Double = driverLocation.position.latitude - 0.0001
        let padLong : Double = driverLocation.position.longitude  + 0.0001
        self.locationTrackingLabel.textColor = .redColor()

        let position = CLLocationCoordinate2D(latitude: (padLat), longitude: (padLong))
        
        driverLocation.position = position
        
        let riderLoc = CLLocation(latitude: self.rider.location.coordinate.latitude, longitude: self.rider.location.coordinate.longitude)
        let driverLoc = CLLocation(latitude: driverLocation.position.latitude, longitude: driverLocation.position.longitude)
        
        let distanceInMeters = riderLoc.distanceFromLocation(driverLoc)
        let distanceInMiles = distanceInMeters/1609.344
        let distanceString = String(format: "%.1f miles away from you", distanceInMiles)
        
        driverLocation.snippet = distanceString

        print(distanceInMiles)
        
        if previousDistanceInMiles == 0.0 {
            //set initial value of previousDistanceInMiles to current distance
            previousDistanceInMiles = distanceInMiles
            updateArrivalTime()
            self.locationTrackingLabel.hidden = false
        }
        
        if previousDistanceInMiles.roundToPlaces(1) != distanceInMiles.roundToPlaces(1) {
            //driver made signficant change in distance
            updateArrivalTime()
            previousDistanceInMiles = distanceInMiles

        }
        
        if driverLocation.map == nil {
            //trip was cancelled
            timer.invalidate()
            self.locationTrackingLabel.textColor = .blackColor()
        }
        
    }
    
    //TODO: could move this to location helper
    private func updateArrivalTime(){
        let requestUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=ls29aa&destinations=ls119bn&mode=driving"
        Alamofire.request(.GET, requestUrl, parameters: ["foo": "bar"])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let result = response.result.value {
                        let time: String = ("\(JSON(result)["rows"][0]["elements"][0]["duration"]["text"])")
                        self.locationTrackingLabel.text = "Pickup time: \(time)"
                    }
                case .Failure(let error):
                    print(error)
                }
        }
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
    
    private func setupCancelButton(){
        cancelTripButton = UIButton()
        cancelTripButton.setTitle("Cancel Pickup", forState: .Normal)
        cancelTripButton.backgroundColor = .whiteColor()
        cancelTripButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        cancelTripButton.alpha = 0.4
        
        view.addSubview(cancelTripButton)

        cancelTripButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        cancelTripButton.heightAnchor.constraintEqualToAnchor(view.heightAnchor,
                                                              multiplier: 0.1).active = true
        
        cancelTripButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor,
                                                             multiplier: 0.5).active = true
        
        cancelTripButton.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor, constant: -10).active = true
        
        cancelTripButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelTripButton.userInteractionEnabled = true

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cancelTrip))
        cancelTripButton.addGestureRecognizer(longPressRecognizer)
        
    }
    
    func cancelTrip(sender : UIGestureRecognizer){
        if sender.state == .Ended {
            startNetworkActivity()
            self.cancelTripButton.hidden = !self.cancelTripButton.hidden
            self.locationTrackingLabel.text = "Pickup Cancelled"
            driverLocation.map = nil
            self.currentTrip!.status = .CANCELLED
            toggleTripMode()
        }
        else if sender.state == .Began {
            self.cancelTripButton.alpha = 1
            self.locationTrackingLabel.text = "Cancelling Pickup ... "

            //TODO: send cancel request through network
        }
    }
    
    private func toggleTripMode(){
        self.locationTrackingLabel.userInteractionEnabled = !self.locationTrackingLabel.userInteractionEnabled
        self.pickupBtn.hidden = !self.pickupBtn.hidden
        self.mapPin.hidden = !self.mapPin.hidden

        if self.currentTrip!.status == .CANCELLED {
            mapView.animateToLocation(CLLocationCoordinate2D(latitude: self.rider.location.coordinate.latitude, longitude: self.rider.location.coordinate.longitude))
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
        
        pickupBtn.addTarget(self, action: "createPickupRequest", forControlEvents: .TouchUpInside)
        
    }
    
    func createPickupRequest() {
        //TODO: current trip should be initialized at first call so that trip status is NEW not nil
        self.currentTrip = Trip(rider: self.rider)
        navigationController?.pushViewController(ConfirmPickupFormController(trip: currentTrip!), animated: true)
    }
    
    
    func setupViewObservers() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleLocationAuthorizationState), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    func handleLocationAuthorizationState(){
        if !userLocationPermissionEnabled! {
            var alertController = UIAlertController (title: "Location Required", message: "You have disabled location usage. Kindly visit your settings and turn it on ", preferredStyle: .Alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            setRiderLocationOnMap()
            print("view loaded from background ")

        }
        
    }
    
    
    func setupNetworkIndicatory(){
        let cols = 4
        let rows = 8
        let cellWidth = Int(self.view.frame.width / CGFloat(cols))
        let cellHeight = Int(self.view.frame.height / CGFloat(rows))
        
        (NVActivityIndicatorType.BallPulse.rawValue ... NVActivityIndicatorType.AudioEqualizer.rawValue).forEach {
            let x = ($0 - 1) % cols * cellWidth
            let y = ($0 - 1) / cols * cellHeight
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                type: NVActivityIndicatorType(rawValue: $0)!)
            let animationTypeLabel = UILabel(frame: frame)
            
            animationTypeLabel.text = String($0)
            animationTypeLabel.sizeToFit()
            animationTypeLabel.textColor = UIColor.whiteColor()
            animationTypeLabel.frame.origin.x += 5
            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
            
            activityIndicatorView.padding = 20
            if ($0 == NVActivityIndicatorType.Orbit.rawValue) {
                activityIndicatorView.padding = 0
            }
            self.view.addSubview(activityIndicatorView)
            self.view.addSubview(animationTypeLabel)
            activityIndicatorView.startAnimation()
            
            let button:UIButton = UIButton(frame: frame)
            button.tag = $0
            button.addTarget(self,
                action: #selector(buttonTapped(_:)),
                forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
        }
    }
    
    func startNetworkActivity(){
        let size = CGSize(width: 30, height:30)
        
        startActivityAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        performSelector(#selector(delayedStopActivity),
                        withObject: nil,
                        afterDelay: 2.5)
    }
    
    func delayedStopActivity() {
        stopActivityAnimating()
    }
}


