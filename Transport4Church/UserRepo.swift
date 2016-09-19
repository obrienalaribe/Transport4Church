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

                    pictureQuery.getFirstObjectInBackgroundWithBlock({ (user, error) in
                        if user != nil {
                            print("SO WHY THE HELL ARE YOU SAVING A NEW PICTURE ? ")
                            
                            print(user)
                            
                            let query = PFQuery(className: "Picture")
                            query.whereKey("owner", equalTo: user!)
                            
                            //update the existing user's dp
                            query.findObjectsInBackgroundWithBlock({ (pictureObject, error) in
                                print("found \(pictureObject) to update on server")
                            })
                        }else{
                            
                            let pictureObject  = PFObject(className: "Picture")
                            
                            let pictureFile = PFFile(name: "image.png", data: data)
                            
                            pictureObject.setObject(currentUser, forKey: "owner")
                            
                            //Save image file on server first
                            pictureFile?.saveInBackgroundWithBlock({ (success, error) in
                                if let error = error {
                                    let errorString = error.userInfo["error"] as? NSString
                                    print(errorString)
                                } else {
                                    //set pointer to file on picture object
                                    pictureObject.setObject(pictureFile!, forKey: "image")
                                    pictureObject.saveInBackgroundWithBlock({ (success, error) in
                                        print("saved image through network and pinning to background")
//                                        pictureObject.pinInBackground()
                                        print(pictureObject)
                                    })
                                    
                                    
                                }
                            })

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
        query.whereKey("owner", equalTo: user)
//        query.cachePolicy = .CacheOnly
        
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
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) pics.")
//                // Do something with the found objects
//                if let objects = objects {
//                    for object in objects {
//                        if let userPicture = object.valueForKey("image") {
//                            let picture = userPicture as! PFFile
//                            //TODO: optimize this to only use and fetch one image object
//                            picture.getDataInBackgroundWithBlock({
//                                (imageData: NSData?, error: NSError?) -> Void in
//                                if (error == nil) {
//                                    let image = UIImage(data:imageData!)
//                                    imageView.contentMode = .ScaleAspectFit
//                                    imageView.clipsToBounds = true
//                                    
//                                    let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
//                                    
//                                    let portraitImage  : UIImage = UIImage(CGImage: image!.CGImage! ,
//                                        scale: 1.0 ,
//                                        orientation: UIImageOrientation.Right)
//                                    
//                                    imageView.image = Helper.resizeImage(portraitImage, toTheSize: size)
//                                }
//                            })
//                        }
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }

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
    
   
}