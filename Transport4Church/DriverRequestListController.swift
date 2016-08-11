//
//  DriverRequestListController.swift
//  Transport4Church
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit

let cellId = "cellId"

class DriverRequestListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Pickup Requests"
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 10
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.registerClass(PickupRequestCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 140)

    }
}

class PickupRequestCell : BaseCollectionCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .redColor()
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Emma Smith"
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
    
    override func setupViews() {
        backgroundColor = .whiteColor()
        
        addSubview(profileImageView)
        addSubview(dividerLineView)

        addConstraintsWithFormat("H:|-12-[v0(80)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(80)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraintsWithFormat("H:|-100-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]-48-|", views: dividerLineView)
        
        setupDetailView()
        setupActionButtons()

    }
    
    private func setupDetailView() {
        let detailView = UIView()
        addSubview(detailView)
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: detailView)
        addConstraintsWithFormat("V:|-5-[v0(90)]", views: detailView)
//        addConstraint(NSLayoutConstraint(item: detailView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        detailView.addSubview(nameLabel)
        detailView.addSubview(timeLabel)
        detailView.addSubview(addressLabel)

        detailView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0][v1(60)]", views: nameLabel, addressLabel)
        
        detailView.addConstraintsWithFormat("H:|[v0]|", views: addressLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)
        
    }
    
    
    private func setupActionButtons(){
        let actionButtonContainer = UIView()
        addSubview(actionButtonContainer)
        actionButtonContainer.backgroundColor = .purpleColor()
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: actionButtonContainer)
        addConstraintsWithFormat("V:[v0(40)]|", views: actionButtonContainer)
        
        

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