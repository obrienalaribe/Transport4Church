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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let mapPin : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "map_pin")
        return view
    }()
    
    let brandLogo  : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "brand_logo")
        view.backgroundColor = UIColor.red
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
        
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height ))
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.setMinZoom(12, maxZoom: 16)
        
                
        view.addSubview(mapView)
        
        print(self.mapView.myLocation)
        
        setupLocationTrackingLabel()
        setupMapPin()
        setupPickupButton()
        setupViewObservers()
        
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(RiderPickupController.showMenu))
        menuBtn.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = menuBtn
        
        cancelTripBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(RiderPickupController.cancelTripAlert))
        
        cancelTripBtn.tintColor = UIColor.clear
        navigationItem.rightBarButtonItem = cancelTripBtn
        cancelTripBtn.isEnabled = false
        
    }
    
    
    func showMenu() {
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.present(menuNavCtrl, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        self.pickupBtn.isUserInteractionEnabled = false
        
        print("seting up rider and trip")
        if let location = locationManager.location {
            self.riderMapViewDidInitialiseWithLocation = true

            //TODO: You should not create a new rider everytime (use optional)
            let rider = Rider()
            
            rider.user = PFUser.current()!
            
            self.currentTrip = Trip()
            self.currentTrip.rider = rider
            self.currentTrip.rider.location = PFGeoPoint(location: location)
            self.currentTrip.status = TripStatus.NEW
            
            let riderLatitude = self.currentTrip.rider.location.latitude
            let riderLongitude = self.currentTrip.rider.location.longitude
            
//            mapView.camera = GMSCameraPosition.cameraWithLatitude(riderLatitude, longitude: riderLongitude, zoom: 14.0)
       
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: riderLatitude, longitude: riderLongitude))
            mapView.animate(toZoom: 15)
            
            
        }else{
            self.riderMapViewDidInitialiseWithLocation = false
            
            print("location service not enabled")

        }
        
       
    }
    
    func setupActiveTripModeView(_ position: CLLocationCoordinate2D){

        print("trip mode activated ")
        toggleViewForCurrentTripMode(state: .STARTED)
    
        driverLocation = GMSMarker(position: position)
        driverLocation.isFlat = true
        
        driverLocation.icon = UIImage(named: "bus")!.withRenderingMode(.alwaysTemplate)
        driverLocation.map = mapView
      
        let bounds = GMSCoordinateBounds(coordinate: self.currentTrip.rider.address.coordinate, coordinate: driverLocation.position)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))!
        self.mapView.camera = camera
        
        setupCallDriverButton()
    
    }
    
    func updateDriverMarker(_ position: CLLocationCoordinate2D){
      
        print("updating driver location on map")
        driverLocation.position = position
        
        let riderLoc = CLLocation(latitude: self.currentTrip.rider.address.coordinate.latitude, longitude: self.currentTrip.rider.address.coordinate.longitude)
        let driverLoc = CLLocation(latitude: driverLocation.position.latitude, longitude: driverLocation.position.longitude)
        
        let distanceInMeters = riderLoc.distance(from: driverLoc)
        var distanceInMiles = distanceInMeters/1609.344
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
    
    fileprivate func setupLocationTrackingLabel() {
        let margins = view.layoutMarginsGuide
        view.addSubview(locationTrackingLabel)
        
        locationTrackingLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        locationTrackingLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        locationTrackingLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                                constant: 8.0).isActive = true
        locationTrackingLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTrackingLabel.backgroundColor = UIColor.white
        locationTrackingLabel.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                                   multiplier: 0.1).isActive = true
        locationTrackingLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(updateLocationAction))
        locationTrackingLabel.addGestureRecognizer(tap)
    }
    
    func updateLocationAction(_ sender:UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    fileprivate func setupCallDriverButton(){
        callDriverBtn = UIButton()
        callDriverBtn.setTitle("Call Driver", for: UIControlState())
        callDriverBtn.backgroundColor = UIColor.white
        callDriverBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        
        callDriverBtn.alpha = 0.4
        
        view.addSubview(callDriverBtn)

        callDriverBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callDriverBtn.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                              multiplier: 0.1).isActive = true
        
        callDriverBtn.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                             multiplier: 0.5).isActive = true
        
        callDriverBtn.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10).isActive = true
        
        callDriverBtn.translatesAutoresizingMaskIntoConstraints = false
        
        callDriverBtn.addTarget(self, action: #selector(RiderPickupController.callDriver), for: .touchUpInside)
        
    }
    
    func callDriver(){
        let alertController = UIAlertController (title: "Call Driver", message: "Would you like to call the driver?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Yes, Call Driver", style: .default) { (_) -> Void in
            if let driver = self.currentTrip.driver {
                let driverContact = driver["contact"] as! String
                if let url = URL(string: "tel://\(driverContact)") {
                    UIApplication.shared.openURL(url)
                }
            }
           
        }
        
        let cancelAction = UIAlertAction(title: "No, Cancel", style: .default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func toggleViewForCurrentTripMode(state: TripStatus){
        //TODO: You should pass in the state of the trip rather than use
        // the global state to execute view changes- BAD PRACTICE
        
        if state == TripStatus.REQUESTED {
            self.tripDetailController.removeFromParentViewController()
            self.tripDetailController.view.removeFromSuperview()
        }
        
        if state == TripStatus.STARTED {
            self.locationTrackingLabel.isUserInteractionEnabled = false
            self.pickupBtn.isHidden = true
            self.mapPin.isHidden = true
            self.cancelTripBtn.isEnabled = true
            self.cancelTripBtn.tintColor = UIColor.black
        }
       
        if state == TripStatus.CANCELLED {
            self.locationTrackingLabel.isUserInteractionEnabled = true
            self.pickupBtn.isHidden = false
            self.mapPin.isHidden = false
            self.cancelTripBtn.isEnabled = false
            self.cancelTripBtn.tintColor = UIColor.clear
            
            if driverLocation != nil {
                //remove driver marker from map
                driverLocation.map = nil
                self.callDriverBtn.isHidden = true
            }
            
           setRiderLocationOnMap()
        }
        
    }
    
    fileprivate func setupMapPin(){
        mapView.addSubview(mapPin)
        mapPin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapPin.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        mapPin.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupPickupButton(){
        pickupBtn = UIButton()
        pickupBtn.layer.cornerRadius = 12
        pickupBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        pickupBtn.setTitle("Pick me up here", for: UIControlState())
        pickupBtn.backgroundColor = UIColor(white: 1, alpha: 1)
        pickupBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        mapView.addSubview(pickupBtn)
        
        pickupBtn.centerXAnchor.constraint(equalTo: mapPin.centerXAnchor).isActive = true
        pickupBtn.centerYAnchor.constraint(equalTo: mapPin.centerYAnchor, constant: -18).isActive = true
        pickupBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        pickupBtn.translatesAutoresizingMaskIntoConstraints = false
        
        pickupBtn.addTarget(self, action: #selector(RiderPickupController.createPickupRequest), for: .touchUpInside)
    }
    
    func createPickupRequest() {
        //TODO: current trip should be initialized at first call so that trip status is NEW not nil
        navigationController?.pushViewController(ConfirmPickupFormController(trip: self.currentTrip), animated: true)
    }
    
    func setupViewObservers() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handleViewStateFromBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func handleLocationAuthorizationState(){
        if !riderMapViewDidInitialiseWithLocation! {
            let alertController = UIAlertController (title: "Location Required", message: "You have disabled location usage. Kindly visit your settings and turn it on ", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            setRiderLocationOnMap()
            print("view loaded from background ")

        }
        
    }
    

    
    func startNetworkActivityForCancelledTrip(){
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "Please wait", type: NVActivityIndicatorType(rawValue: 17)!)
        perform(#selector(delayedStopActivity),
                        with: nil,
                        afterDelay: 2.5)
        toggleViewForCurrentTripMode(state: .CANCELLED)
    }
    
    func delayedStopActivity() {
        stopAnimating()
        self.locationTrackingLabel.alpha = 1
        self.mapView.alpha = 1
        self.animatePickupBtn()
    }
    
    func modallyDisplayTripDetails(){

        tripDetailController = RiderTripDetailController(trip: currentTrip)
        tripDetailController.delegate = self
        tripDetailController.willMove(toParentViewController: self)
        self.view.addSubview(tripDetailController.view)
        self.addChildViewController(tripDetailController)
        tripDetailController.didMove(toParentViewController: self)
        self.mapView.alpha = 0.5
        self.locationTrackingLabel.alpha = 0.1

        tripDetailController.view.alpha = 1
        
    }
    
    func cancelTripAlert(){
        let alertController = UIAlertController (title: "Cancel Pickup", message: "Are you sure you would like to cancel your pickup? The driver would not be able to pick you up", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes, Cancel Pickup", style: .default) { (_) -> Void in
            //TODO: Send socket request to notify the driver
            
            self.currentTrip.status = .CANCELLED
            self.currentTrip.saveInBackground(block: { (success, error) in
                self.startNetworkActivityForCancelledTrip()

            })
        }
        
        let cancelAction = UIAlertAction(title: "Exit", style: .default) { (_) -> Void in
            
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func listenForSocketConnection(){
        let userID = self.currentTrip.rider.user.objectId!
        SocketIOManager.sharedInstance.getDriverLocationUpdate(forUser: userID) { (locationInfo) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                //run ui updates on main thread
                
                if self.currentTrip.status == .REQUESTED {
                    self.toggleViewForCurrentTripMode(state: .REQUESTED)

                    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.9 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                        let banner = Banner(title: "Pickup Request Accepted!!", subtitle: "The church bus is on its way now", image: UIImage(named: "bus"), backgroundColor: BrandColours.primary.color)
                        banner.dismissesOnTap = false
                        banner.show(duration: 3.0)
                        
                        banner.didTapBlock?(())
                    })
                    
                    self.mapView.alpha = 1
                    self.locationTrackingLabel.alpha = 1
                    
                    self.currentTrip.status = .STARTED
                    self.currentTrip.saveEventually()
                    self.setupActiveTripModeView(locationInfo)
                    
                    //TODO: Schedule from remote notification
                    NotificationHelper.scheduleLocal("The church bus is on its way", status: "accepted", alertDate: Date())
                }
                
                if self.currentTrip.status == .STARTED {
                    self.updateDriverMarker(locationInfo)
                    
                    // TODO: Use PARSE CODE (execute on block for both android and ios)
                    //fetch driver details once trip has started
                    if self.currentTrip.driver == nil {
                        self.currentTrip.fetchInBackground { (trip, error) in
                            if let updatedTrip = trip as? Trip {
                                updatedTrip.driver?.fetchIfNeededInBackground(block: { (object, error) in
                                    if let driverName = updatedTrip.driver?["name"] as? String {
                                        self.driverLocation.title = driverName
                                    }
                                })
                            }
                        }
                    }
                }
                
            })
            //TODO: Need to stop socket on driver
            print("Socket receiving driver location ... ")
            
        }

    }
    
    
    func handleViewStateFromBackground(){
        if self.currentTrip.status == .STARTED {
        }
        
    }
}


