//
//  DriverRequestListController.swift
//  Transport4Church
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import SCLAlertView

let cellId = "cellId"
var numberOfRequest = 3
let EFA_Coord = CLLocationCoordinate2DMake(53.78984874424867, -1.549763830503412)


//TODO: Make all requests come from Parse

class DriverRequestListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var pickupRequests = TripRepo.fetchAllPickupRequests(EFA_Coord)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Pickup Requests"
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 10
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.registerClass(PickupRequestCell.self, forCellWithReuseIdentifier: cellId)
        print(pickupRequests)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickupRequests.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! PickupRequestCell
        
        cell.doneButton.layer.setValue(indexPath, forKey: "indexPath")
        
        cell.trip = pickupRequests[indexPath.row] as! Trip
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width - 20, 140)
    }
}

class PickupRequestCell : BaseCollectionCell {
    
    var trip : Trip? {
        didSet {
            fakeTrips.sort({$0.pickupTime.compare($1.pickupTime) == .OrderedAscending })
            
         
            if let pickupTime = trip?.pickupTime {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                timeLabel.text = dateFormatter.stringFromDate(pickupTime)

            }
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
        label.text = "Emma Smith + 3"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.boldSystemFontOfSize(18)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "10 William Street \n Hyde Park, Leeds \n SG2 9SL"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:05 pm"
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
        button.setTitle("Done", forState: .Normal)
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

        callButton.addTarget(self, action: "handleCallEvent", forControlEvents: .TouchUpInside)
        actionButtonContainer.addSubview(callButton)
       
        doneButton.addTarget(self, action: "handleCompleteEvent:", forControlEvents: .TouchUpInside)
        actionButtonContainer.addSubview(doneButton)

        actionButtonContainer.addConstraintsWithFormat("H:|[v0][v1(v0)]|", views: callButton, doneButton)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: callButton)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: doneButton)
        
    }
    
    
    func handleCallEvent(){
        let riderPhone: Int64 = 07778889077
        if let url = NSURL(string: "tel://\(riderPhone)") {
            UIApplication.sharedApplication().openURL(url)
        }
        print("calling \(riderPhone)")
    }
    
    func handleCompleteEvent(sender: UIButton!){
        let buttonIndex : NSIndexPath = (sender.layer.valueForKey("indexPath")) as! NSIndexPath
        let parent = self.superview as! UICollectionView

        numberOfRequest = numberOfRequest - 1

        if numberOfRequest > 0 {
            parent.deleteItemsAtIndexPaths([buttonIndex])
        }else {
            numberOfRequest = 0
            parent.reloadData()
            
            SCLAlertView().showTitle(
                "Congratulations", // Title of view
                subTitle: "Pickup successfully completed", // String of view
                duration: 5.0, // Duration to show before closing automatically, default: 0.0
                completeText: "Done", // Optional button value, default: ""
                style: .Success, // Styles - see below.
                colorStyle: 0x00EE00,
                colorTextButton: 0xFFFFFF
            )
        }

        print(buttonIndex.row)
        
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