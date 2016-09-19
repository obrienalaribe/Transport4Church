//
//  ProfileViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka
import Parse

class ProfileViewController : UIViewController {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.image = UIImage(named: "user_male")
        imageView.layer.zPosition = 2
        return imageView
    }()
    
    let profileContent: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        return view
    }()
    
    let editBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", forState: .Normal)
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.purpleColor().CGColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        btn.backgroundColor = UIColor.whiteColor()
        btn.tintColor = .purpleColor()
        btn.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        return btn
    }()
    
    let logoutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", forState: .Normal)
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.darkGrayColor().CGColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        btn.backgroundColor = UIColor.whiteColor()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.layer.zPosition = 2
        return btn
    }()
  
    var nameLabel : UILabel!
    var churchLabel : UILabel!
    var roleLabel : UILabel!
    
    var currentUser : PFUser!
    let userRepo = UserRepo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        if let user = PFUser.currentUser() {
            currentUser = user
          
            view.addSubview(profileImageView)
            view.backgroundColor = UIColor(white: 0.97, alpha: 1)
            
            profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            
            profileImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant:  -150).active = true
            
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(profileContent)
            
            let margins = view.layoutMarginsGuide
            
            profileContent.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
            profileContent.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
            profileContent.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor,
                                                             constant: -30.0).active = true
            
            profileContent.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor,
                                                                constant: -60.0).active = true
            
            profileContent.backgroundColor = .whiteColor()
            
            profileContent.translatesAutoresizingMaskIntoConstraints = false
            
            
            let profileContentMargin = profileContent.layoutMarginsGuide
            
            setupLogoutBtn(profileContentMargin)
            setupEditBtn(profileContentMargin)
            setupNameLabel(profileContentMargin)
            setupChurchLabel(profileContentMargin)
            setupRoleLabel(profileContentMargin)
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        userRepo.fetchAndSetUsersProfileImage(currentUser, imageView: self.profileImageView)
    }
    
    func setupEditBtn(parentMargin : UILayoutGuide){
        profileContent.addSubview(editBtn)
        
        editBtn.topAnchor.constraintEqualToAnchor(profileContent.topAnchor, constant: 40).active = true
        
        editBtn.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        editBtn.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        
        editBtn.addTarget(self, action: #selector(ProfileViewController.editProfileAction), forControlEvents: .TouchUpInside)
    }
   
    func editProfileAction(){
        self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    func setupNameLabel(parentMargin : UILayoutGuide){
        nameLabel = createProfileLabel(userRepo.extractUserField("name"))
        
        profileContent.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraintEqualToAnchor(editBtn.bottomAnchor, constant: 20).active = true
        
        nameLabel.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        nameLabel.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupChurchLabel(parentMargin : UILayoutGuide){
        churchLabel = createProfileLabel("Church: EFA RCCG Leeds \n 13-17 Walter Street \n Leeds, LS3 4BB")
        churchLabel.numberOfLines = 3
        
        profileContent.addSubview(churchLabel)
        
        churchLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 10).active = true
        
        churchLabel.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        churchLabel.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        churchLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRoleLabel(parentMargin : UILayoutGuide){
        roleLabel = createProfileLabel("Joined as \(userRepo.extractUserField("role")) \n \(Helper.convertDateToString(currentUser.createdAt!))")
        roleLabel.numberOfLines = 2

        profileContent.addSubview(roleLabel)
        
        roleLabel.topAnchor.constraintEqualToAnchor(churchLabel.bottomAnchor, constant: 10).active = true
        
        roleLabel.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        roleLabel.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLogoutBtn(parentMargin : UILayoutGuide){
        view.addSubview(logoutBtn)
        
        logoutBtn.topAnchor.constraintEqualToAnchor(profileContent.bottomAnchor, constant: 10).active = true
        
        logoutBtn.leadingAnchor.constraintEqualToAnchor(parentMargin.leadingAnchor).active = true
        
        logoutBtn.trailingAnchor.constraintEqualToAnchor(parentMargin.trailingAnchor).active = true
        
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        logoutBtn.addTarget(self, action: #selector(ProfileViewController.logout), forControlEvents: .TouchUpInside)
        
    }

    func logout(){
        PFUser.logOut()
        self.navigationController?.setViewControllers([AuthViewController()], animated: true)
    }
    
    private func createProfileLabel(title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor.darkGrayColor()
        label.text = title
        label.textAlignment = .Center
        return label
    }
    
 
    
}

