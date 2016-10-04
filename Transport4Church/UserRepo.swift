//
//  UserRepo.swift
//  Transport4Church
//
//  Created by mac on 8/20/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

struct Credentials {
    var username : String
    var password : String
    var role: String
}

struct Profile {
    var image : UIImage?
    var name: String
    var gender: String
    var contact : String
    var church : String
}

class UserRepo {
    
    func updateProfile(profile: Profile, listener: UIViewController){
        
        if let currentUser = getCurrentUser() {
            if let image = profile.image {
                let imageData = UIImagePNGRepresentation(image)
                
                if let data = imageData {
                    
                    //check if user already has profile pic
                    let pictureQuery = PFQuery(className: "Picture")
                    
                    pictureQuery.whereKey("owner", equalTo: currentUser)
                    pictureQuery.includeKey("owner")

                    pictureQuery.getFirstObjectInBackgroundWithBlock({ (pictureObject, error) in
                        if pictureObject != nil {
                            self.createOrUpdateUserAvatar(pictureObject!, data: data)
                            
                        }else{
                            let pictureObject  = PFObject(className: "Picture")
                            self.createOrUpdateUserAvatar(pictureObject, data: data)

                        }
                    })
              
                }
            }
            
            currentUser["name"] = profile.name
            currentUser["gender"] = profile.gender
            currentUser["contact"] = profile.contact
            currentUser["church"] = profile.church

            currentUser.saveInBackgroundWithBlock({ (success, error) in
                
                if listener.navigationController?.viewControllers.count == 1 {
                    //registration stage
                    
                    if currentUser["role"] as! String == UserRoles.Driver.rawValue {
                        listener.navigationController?.setViewControllers([DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
                    }else{
                        listener.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                    }
                }else{
                    //was accessed through settings
                    listener.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        

    }
    
    func authenticate(credentials: Credentials, listener: UIViewController) {
        let user = PFUser()
        user.username = credentials.username
        user.email = credentials.username
        user.password = credentials.password
        user["role"] = credentials.role
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                
                if error.code == 202 {
                    print("user already exist so login and navigate to rider view")
                    
                    PFUser.logInWithUsernameInBackground(credentials.username, password: credentials.password) {(user: PFUser?, error: NSError?) -> Void in
                        if user != nil {
                            print(PFUser.currentUser()!)
                            listener.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                            
                        } else {
                            print("user log in failed")
                        }
                    }
                    
                    if let user = PFUser.currentUser() {
                        print(PFUser.currentUser()!)
                        listener.navigationController?.setViewControllers([RiderPickupController()], animated: true)
                    }else{
                        
                        //TODO: User logged in with existing email but wrong password. USe alert 
                    }
                 
                }else{
                    let errorString = error.userInfo["error"] as? NSString
                    print(" \(errorString)")
                }
                
            } else {
                print("saved new user")

                print(PFUser.currentUser()!)                
                listener.navigationController?.setViewControllers([EditProfileViewController()], animated: true)
                
                
            }
            
        }

    }
    
    func fetchAndSetUsersProfileImage(user: PFUser, imageView: UIImageView){
        let query = PFQuery(className:"Picture")
        query.cachePolicy = .CacheElseNetwork
        query.whereKey("owner", equalTo: user)
        
        query.getFirstObjectInBackgroundWithBlock { (result, error) in
            if let pictureObject = result {
                if let userPicture = pictureObject.valueForKey("image") {
                    let picture = userPicture as! PFFile
                    //TODO: optimize this to only use and fetch one image object
                    picture.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            imageView.contentMode = .ScaleAspectFit
                            imageView.clipsToBounds = true
                            
                            let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
                            
                            let portraitImage  : UIImage = UIImage(CGImage: image!.CGImage! ,
                                scale: 1.0 ,
                                orientation: UIImageOrientation.Right)
                            
                            imageView.image = Helper.resizeImage(portraitImage, toTheSize: size)
                        }
                    })
                }

            }
            
        }
    }
    
    func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    
    func extractUserField(field : String) -> String{
        if let user = getCurrentUser() {
            if let field = user[field] {
                return field as! String
            }
        }
        return ""
    }
    
    private func createOrUpdateUserAvatar(pictureObject: PFObject, data: NSData){
     
        let pictureFile = PFFile(name: "image.png", data: data)
        
        pictureObject.setObject(PFUser.currentUser()!, forKey: "owner")
        
        pictureObject.setObject(pictureFile!, forKey: "image")
        pictureObject.saveInBackgroundWithBlock({ (success, error) in
            print("saved image through network and pinning to background")
            print(pictureObject)
            pictureObject.pinInBackground()

        })
        

    }
    
    static func configureAppLaunchCount(){
        
        //set up user default to detect fresh user
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let count = defaults.stringForKey(appLaunchCount) {
            let newCount = Int(count)! + 1
            print("launch count is \(count) incrementing to \(newCount) ")
            defaults.setObject(newCount, forKey: appLaunchCount)
        }else{
            //new user
            defaults.setObject(1, forKey: appLaunchCount)
        }
    }
    
    static func getAppLaunchCount() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let count = defaults.stringForKey(appLaunchCount) {
            return Int(count)!
        }
        return 0
    }
    
   
}