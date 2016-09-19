//
//  DriverRequestListController.swift
//  Transport4Church
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import SCLAlertView
import Parse

let cellId = "cellId"
let EFA_Coord = CLLocationCoordinate2DMake(53.79096121417226, -1.552361008974449)
var pickupRequests : [Trip]?


//TODO: Make all requests come from Parse

class DriverRequestListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var tripRepo = TripRepo()
    var listenerResult = [Trip]()
    
    let items = ["New", "Completed", "Cancelled"]
    let status = [TripStatus.REQUESTED, TripStatus.COMPLETED, TripStatus.CANCELLED]
    var tripStatusToggle : UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        tripStatusToggle = UISegmentedControl(items: items)
        tripStatusToggle.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        tripStatusToggle.frame = CGRectMake(frame.minX + 10, frame.minY + 70,
                                    frame.width - 20, frame.height*0.1)
        
        // Style the Segmented Control
        tripStatusToggle.layer.cornerRadius = 5.0  // Don't let background bleed
        tripStatusToggle.backgroundColor = UIColor.darkGrayColor()
        tripStatusToggle.tintColor = UIColor.whiteColor()
        
        // Add target action method
        tripStatusToggle.addTarget(self, action: #selector(DriverRequestListController.changeView(_:)), forControlEvents: .ValueChanged)
        
        // Add this custom Segmented Control to our view
        self.view.addSubview(tripStatusToggle)
        
    }
    
    
    func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            refresh()
        case 2:
            refresh()
        default:
            refresh()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Pickup Requests"
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 10
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.registerClass(PickupRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        let refreshBtn = UIBarButtonItem(image: UIImage(named: "refresh"), style: .Plain, target: self, action: #selector(DriverRequestListController.refresh))
        refreshBtn.tintColor = .blackColor()
        
        self.navigationItem.rightBarButtonItem = refreshBtn

        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(DriverRequestListController.showMenu))
        menuBtn.tintColor = .blackColor()
        
        navigationItem.leftBarButtonItem = menuBtn
        
    }
    
    
    func showMenu(){
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.presentViewController(menuNavCtrl, animated: true, completion: nil)
    }
    
    func refresh(){
        tripRepo.fetchAllPickupRequests(self, tripStatus: status[tripStatusToggle.selectedSegmentIndex])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        
        print(tripStatusToggle.selectedSegmentIndex)
       
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let requests = pickupRequests {
            return requests.count
        }
        return 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! PickupRequestCell
        
        cell.doneButton.layer.setValue(indexPath.row, forKey: "index")
        
        cell.trip = pickupRequests?[indexPath.row]
        
        cell.doneButton.addTarget(self, action: #selector(DriverRequestListController.showDriverTripMode(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width - 20, 140)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(75, 0, 0, 0)
    }
  
    
    func showDriverTripMode(sender: UIButton){
        
        let row = sender.layer.valueForKey("index") as! Int
        let trip : Trip = pickupRequests![row]
        
        trip.status = TripStatus.ACCEPTED
        trip.driver = PFUser.currentUser()!
        trip.saveEventually()
        
        self.navigationController?.setViewControllers([DriverTripViewController(trip: trip)], animated: true)
        
        
    }
}

class PickupRequestCell : BaseCollectionCell {
    
    var trip : Trip? {
        didSet {
            
            trip?.rider.user.fetchInBackgroundWithBlock({ (user, error) in
                self.nameLabel.text = (user)!["name"] as! String
            })
            
            print(trip?.rider.addressDic)
            
            if let street = trip?.rider.addressDic["street"], city = trip?.rider.addressDic["city"],  postcode = trip?.rider.addressDic["postcode"] {
                self.addressLabel.text = "\(street)\n\(city)\n\(postcode)"

                print("\(street) \n \(city) \n \(postcode)")
            }

            
            let dateArr = (trip?["pickup_time"] as! String).characters.split{$0 == ","}.map(String.init)
            
            self.timeLabel.text = dateArr.last
            
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.image = UIImage(named: "user_male")
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.boldSystemFontOfSize(18)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "--------------"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = .Right
        return label
    }()
    
    let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Call", forState: .Normal)
        button.setTitleColor(.darkGrayColor(), forState: .Normal)
        let image = UIImage(named: "Phone-48")
        button.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
        button.setImage(image, forState: .Normal)
//        button.backgroundColor = .purpleColor()
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.contentHorizontalAlignment = .Left
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", forState: .Normal)
        button.setTitleColor(.darkGrayColor(), forState: .Normal)
        let image = UIImage(named: "Ok-48")
        button.titleLabel!.font = UIFont.boldSystemFontOfSize(18)
        button.setImage(image, forState: .Normal)
//        button.backgroundColor = .blackColor()
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.contentHorizontalAlignment = .Left
        
        return button
    }()
    
    override func setupViews() {
        backgroundColor = .whiteColor()
        
        addSubview(profileImageView)

        addConstraintsWithFormat("H:|-12-[v0(80)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(80)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
       
        setupDetailView()
        setupActionButtons()

    }
    
    private func setupDetailView() {
        let detailView = UIView()
        addSubview(detailView)
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: detailView)
        addConstraintsWithFormat("V:|-7-[v0(90)]", views: detailView)
//        addConstraint(NSLayoutConstraint(item: detailView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        detailView.addSubview(nameLabel)
        detailView.addSubview(timeLabel)
        detailView.addSubview(addressLabel)

        detailView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0][v1(60)]", views: nameLabel, addressLabel)
        
        detailView.addConstraintsWithFormat("H:|[v0]|", views: addressLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)

        //place divider under detail view
        
        addSubview(dividerLineView)

        addConstraintsWithFormat("H:|-100-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]-48-|", views: dividerLineView)
        
    }

    
    private func setupActionButtons(){
        let actionButtonContainer = UIView()
        addSubview(actionButtonContainer)
//        actionButtonContainer.backgroundColor = .purpleColor()
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: actionButtonContainer)
        addConstraintsWithFormat("V:[v0(40)]|", views: actionButtonContainer)

        callButton.addTarget(self, action: #selector(PickupRequestCell.handleCallEvent), forControlEvents: .TouchUpInside)
        actionButtonContainer.addSubview(callButton)
       
        doneButton.addTarget(self, action: #selector(PickupRequestCell.handleCompleteEvent(_:)), forControlEvents: .TouchUpInside)
        actionButtonContainer.addSubview(doneButton)

        actionButtonContainer.addConstraintsWithFormat("H:|[v0][v1(v0)]|", views: callButton, doneButton)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: callButton)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: doneButton)
        
    }
    
    
    func handleCallEvent(){
        let riderPhone: String = "07778889077"
        if let url = NSURL(string: "tel://\(riderPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
        print("calling \(riderPhone)")
    }
    
    func handleCompleteEvent(sender: UIButton!){
        let parent = self.superview as! UICollectionView

//        let indexPath = parent.indexPathForCell(self)
//        pickupRequests?.removeAtIndex(indexPath!.row)
//        parent.deleteItemsAtIndexPaths([indexPath!])
//        parent.reloadData()
       
    }

}



class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}